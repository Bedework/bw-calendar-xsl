package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import java.nio.file.FileVisitOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.List;

import static java.lang.String.format;

/** Bedework war files have a set of language specific directories
 * with the 5 character locale name and a default directory used
 * when the language is (US) English.
 *
 * <p>Inside each of these are the language specific strings and
 * possibly some settings and a directory which is browser
 * specific.
 * Mostly this has the name default and contains the root xls file.
 *
 * <p>Additionally we have a themes directory containing most of
 * the xsl.
 *
 * <p>There is also usually a globals.xsl
 */
public class XslWarSource implements Logged {
  public final List<String> locales =
      Arrays.asList("de_DE", "es_ES");

  final WarItem warRoot;
  private WarSourceScanner scanner;

  public XslWarSource(final Path path) {
    warRoot = new WarItem(path);
  }

  public void process() {
    info("Processing war source: " + warRoot.path +
        " -------------------");

    scanner = new WarSourceScanner(this);
    final EnumSet<FileVisitOption> opts = EnumSet.of(
        FileVisitOption.FOLLOW_LINKS);
    try {
      Files.walkFileTree(warRoot.path, opts,
                         Integer.MAX_VALUE,
                         scanner);
    } catch (final Throwable t) {
      throw new BedeworkException(t);
    }

    info("Found " + scanner.numberXsl + " xsl files");
    if (scanner.fileErrors == 1) {
      info("1 file error");
    } else {
      info(scanner.fileErrors + " file errors");
    }

    matchStrings();
    info("------------- List of unreffed string variables");
    showUnreffed();
    info("------------- Matching supported locales");
    checkLocales();
  }

  private void checkLocales() {
    // Ensure each locale has the same variables defined
    final var defaultStringsMap =
        scanner.defaultStringsXsl.variables;

    for (final var locale: locales) {
      final var wi = findWarItem(
          "src", "main", "webapp", locale, "strings.xsl");
      if (wi == null) {
        continue;
      }

      info("Checking locale " + locale);
      final var lvars =
          new HashSet<>(wi.aFile.variables.keySet());
      if (lvars.isEmpty()) {
        info("No variables defined for " + locale);
      }

      final var dvars =
          new HashSet<>(defaultStringsMap.keySet());

      for (final var dvar: dvars) {
        if (!lvars.remove(dvar)) {
          info(format("Variable %s in defaults but not in %s",
                      dvar, locale));
        }
      }

      for (final var lvar: lvars) {
        info(format("Variable %s in %s but not in defaults",
                    lvar, locale));
      }
    }
  }

  public long getNumberXsl() {
    if (scanner == null) {
      return 0;
    }

    return scanner.numberXsl;
  }

  public long getFileErrors() {
    if (scanner == null) {
      return 0;
    }

    return scanner.fileErrors;
  }

  public void matchStrings() {
    for (final var wi: warRoot.dirEntries) {
      if (wi.isDir()) {
        matchStringsInDir(wi, scanner.defaultStringsXsl);
      }
    }
  }

  public void matchStringsInDir(final WarItem dir,
                                final XslFile vars) {
    for (final var wi: dir.dirEntries) {
      if (wi.isDir()) {
        matchStringsInDir(wi, vars);
      } else {
        matchStringsInFile(wi, vars);
      }
    }
  }

  public void matchStringsInFile(final WarItem file,
                                 final XslFile vars) {
    final var theXsl = file.aFile;
    if (theXsl.isStringsXsl) {
      return;
    }

    theXsl.matchVariables(vars);
  }

  public void showUnreffed() {
    scanner.defaultStringsXsl.showUnreffed();
  }

  public long getUnreffedCount() {
    return scanner.defaultStringsXsl.getUnreffedCount();
  }

  private WarItem findWarItem(final String... pathElements) {
    // Top level is the module
    var current = warRoot.dirEntries.getFirst();

    for (final var el: pathElements) {
      current = current.find(el);
      if (current == null) {
        return null;
      }
    }

    return current;
  }

  /* =========================================================
   *                   Logged methods
   * ========================================================= */

  private final BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
