package org.bedework.calendarXsl.checkStrings;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Stack;

import static java.nio.file.FileVisitResult.CONTINUE;

public class WarSourceScanner implements FileVisitor<Path> {
  final XslWarSource theWar;
  final Stack<XslWarSource.WarItem> currentDir = new Stack<>();

  public WarSourceScanner(final XslWarSource theWar) {
    this.theWar = theWar;
    currentDir.push(theWar.warRoot);
  }

  @Override
  public FileVisitResult preVisitDirectory(final Path dir,
                                           final BasicFileAttributes attrs) {
    currentDir.push(new XslWarSource.WarItem(dir));

    return CONTINUE;
  }

  @Override
  public FileVisitResult visitFile(
      final Path file,
      final BasicFileAttributes attrs) {
    if (!file.getFileName().endsWith(".xsl")) {
      return CONTINUE;
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
                                            final IOException exc)
      throws IOException {
    return CONTINUE;
  }
}
