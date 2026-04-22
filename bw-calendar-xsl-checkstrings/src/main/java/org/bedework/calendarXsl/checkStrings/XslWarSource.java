package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import java.nio.file.FileVisitOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;
import java.util.EnumSet;

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
  /**
   * A WarItem is either a file or a directory
   */
  public static class WarItem {
    final Path path;
    final Collection<WarItem> dirEntries;
    final XslFile aFile;

    public WarItem(final Path path) {
      this.path = path;
      aFile = null;
      dirEntries = new ArrayList<>();
    }

    public WarItem(final Path path,
                   final XslFile theFile) {
      this.path = path;
      aFile = theFile;
      dirEntries = null;
    }
  }

  final WarItem warRoot;

  public XslWarSource(final Path path) {
    warRoot = new WarItem(path);
  }

  public void process() {
    if (debug()) {
      debug("Processing war source: " + warRoot.path);
    }

    final WarSourceScanner scanner =
        new WarSourceScanner(this);
    final EnumSet<FileVisitOption> opts = EnumSet.of(
        FileVisitOption.FOLLOW_LINKS);
    try {
      Files.walkFileTree(warRoot.path, opts,
                         Integer.MAX_VALUE,
                         new WarSourceScanner(this));
    } catch (final Throwable t) {
      throw new BedeworkException(t);
    }
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
