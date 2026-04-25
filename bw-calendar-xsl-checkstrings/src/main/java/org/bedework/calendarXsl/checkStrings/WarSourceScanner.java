package org.bedework.calendarXsl.checkStrings;

import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayDeque;
import java.util.Deque;

import static java.nio.file.FileVisitResult.CONTINUE;
import static java.nio.file.FileVisitResult.SKIP_SUBTREE;

public class WarSourceScanner
    implements Logged, FileVisitor<Path> {
  final XslWarSource theWar;
  final Deque<WarItem> currentDir = new ArrayDeque<>();
  long skippedDirs;
  long numberXsl;
  long fileErrors;
  XslFile defaultStringsXsl;

  public WarSourceScanner(final XslWarSource theWar) {
    this.theWar = theWar;
    currentDir.push(theWar.warRoot);
  }

  @Override
  public FileVisitResult preVisitDirectory(final Path dir,
                                           final BasicFileAttributes attrs) {
    if (dir.endsWith("target")) {
      if (debug()) {
        debug("Skip dir " + dir);
      }
      skippedDirs++;
      return SKIP_SUBTREE;
    }

    //if (debug()) {
    //  debug("Previsit dir " + dir);
    //}
    final var warItem = new WarItem(dir);
    currentDir.peek().dirEntries.add(warItem);
    currentDir.push(warItem);

    return CONTINUE;
  }

  @Override
  public FileVisitResult visitFile(
      final Path file,
      final BasicFileAttributes attrs) {
    if (!file.getFileName().toString().endsWith(".xsl")) {
      return CONTINUE;
    }

    final XslFile xslFile;
    try {
      xslFile = new XslFile(file);
      currentDir.peek().dirEntries.
          add(new WarItem(file, xslFile));
      numberXsl++;
    } catch (final Throwable t) {
      error("Unable to parse " + file);
      error(t);
      fileErrors++;

      return CONTINUE;
    }

    if (xslFile.defaultStrings) {
      defaultStringsXsl = xslFile;
    }

    return CONTINUE;
  }

  @Override
  public FileVisitResult visitFileFailed(final Path file,
                                         final IOException exc) {
    return CONTINUE;
  }

  @Override
  public FileVisitResult postVisitDirectory(final Path dir,
                                            final IOException exc) {
    currentDir.pop();

    return CONTINUE;
  }

  /* ==============================================================
   *                   Logged methods
   * ============================================================== */

  private final BwLogger logger = new BwLogger();

  @Override
  public BwLogger getLogger() {
    if ((logger.getLoggedClass() == null) && (logger.getLoggedName() == null)) {
      logger.setLoggedClass(getClass());
    }

    return logger;
  }
}
