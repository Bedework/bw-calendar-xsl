package org.bedework.calendarXsl.checkStrings;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;

/**
 * A WarItem is either a file or a directory
 */
public class WarItem {
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

  public boolean isDir() {
    return dirEntries != null;
  }
}
