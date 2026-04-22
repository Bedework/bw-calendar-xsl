package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.xml.FromXml;

import org.w3c.dom.Document;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.nio.file.Path;

public class XslFile {
  final Path path;
  final Document xsl;

  public XslFile(final Path path) {
    this.path = path;
    try {
      xsl = FromXml.parseXml(new FileReader(path.toFile()));
    } catch (final FileNotFoundException e) {
      throw new BedeworkException(e);
    }
  }
}
