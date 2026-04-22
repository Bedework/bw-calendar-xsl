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

  public void addWarSource(final String pathStr) {
    final var warSourcePath = Paths.get(pathStr);
    if (!warSourcePath.toFile().isDirectory()) {
      throw new BedeworkException(
          warSourcePath + " is not a directory");
    }

    warSources.add(new XslWarSource(warSourcePath));
  }

  final void process() {
    for (final var ws: warSources) {
      ws.process();
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
