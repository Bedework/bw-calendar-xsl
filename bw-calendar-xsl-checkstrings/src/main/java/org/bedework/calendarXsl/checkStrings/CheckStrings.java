package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.args.Args;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;

import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;

public class CheckStrings implements Logged {
  final Collection<XslWarSource> warSources = new ArrayList<>();
  long numberXsl;
  long fileErrors;
  long noSelectCopyOf;

  public void addWarSource(final String pathStr) {
    final var warSourcePath = Paths.get(pathStr);
    if (!warSourcePath.toFile().isDirectory()) {
      throw new BedeworkException(
          warSourcePath + " is not a directory");
    }

    warSources.add(new XslWarSource(warSourcePath));
  }

  final void process() {
    numberXsl = 0;
    fileErrors = 0;
    for (final var ws: warSources) {
      ws.process();
      numberXsl += ws.getNumberXsl();
      fileErrors += ws.getFileErrors();
      noSelectCopyOf += ws.getNoSelectCopyOf();
    }

    total("xsl file", numberXsl);
    total("file error", fileErrors);
    total("No select in copy-of element", noSelectCopyOf);
  }

  private void total(final String title, final long count) {
    if (count == 1) {
      info(title + ": " + count);
    } else {
      info(title + "s: " + count);
    }
  }

  /**
   *
   * @param args comma separated list of paths to xsl war source.
   */
  public static void main(final String[] args) {
    final var cs = new CheckStrings();

    try {
      final Args pargs = new Args(args);

      while (pargs.more()) {
        for (final var pathStr: pargs.next().split(",")) {
          cs.addWarSource(pathStr);
        }
      }

      cs.process();
    } catch (final Throwable t) {
      t.printStackTrace();
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
