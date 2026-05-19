package org.bedework.calendarXsl.checkStrings;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * A WarItem is either a file or a directory
 */
public class WarItem {
  final Path path;
  final String name;
  final List<WarItem> dirEntries;
  final XslFile aFile;

  public WarItem(final Path path) {
    this.path = path;
    name = path.getName(path.getNameCount() - 1).toString();
    aFile = null;
    dirEntries = new ArrayList<>();
  }

  public WarItem(final Path path,
                 final XslFile theFile) {
    this.path = path;
    name = path.getName(path.getNameCount() - 1).toString();
    aFile = theFile;
    dirEntries = null;
  }

  public boolean isDir() {
    return dirEntries != null;
  }

  public WarItem find(final String name) {
    if (dirEntries == null) {
      return null;
    }

    for (final var wi: dirEntries) {
      if (wi.name.equals((name))) {
        return wi;
      }
    }

    return null;
  }
}
