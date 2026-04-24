package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.xml.FromXml;
import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

import javax.xml.namespace.QName;

public class XslFile implements Logged {
  final static String nsXSL =
      "http://www.w3.org/1999/XSL/Transform";

  final static QName xslStylesheet =
      new QName(nsXSL, "stylesheet");

  final static QName xslVariable =
      new QName(nsXSL, "variable");

  final static QName xslCopyOf =
      new QName(nsXSL, "copy-of");

  final Path path;
  final Document xsl;
  final boolean isStylesheet;
  final boolean isStringsXsl;
  final boolean defaultStrings;

  final Map<String, XslVariable> variables = new HashMap<>();

  public XslFile(final Path path) {
    this.path = path;
    isStringsXsl = path.endsWith("strings.xsl");
    defaultStrings = path.endsWith("default/strings.xsl");
    try {
      xsl = FromXml.parseXml(new FileReader(path.toFile()));
    } catch (final FileNotFoundException e) {
      throw new BedeworkException(e);
    }

    // Root should be xsl:stylesheet
    if (!XmlUtil.nodeMatches(xsl, xslStylesheet)) {
      isStylesheet = false;
      return;
    }

    isStylesheet = true;

    if (!isStringsXsl) {
      return;
    }

    for (final var nd: XmlUtil.getNodes(xsl)) {
      if (!XmlUtil.nodeMatches(nd, xslVariable)) {
        continue;
      }
      final var name = nd.getAttributes()
                         .getNamedItem("name")
                         .getNodeValue();
      variables.put(name,
                    new XslVariable(name,
                                    nd.getNodeValue()));
    }
  }

  public void matchVariables(final XslFile vars) {
    for (final var nd: XmlUtil.getNodes(xsl)) {
      matchVariables(nd, vars);
    }
  }

  private void matchVariables(final Node nd,
                              final XslFile vars) {
    if (XmlUtil.nodeMatches(nd, xslCopyOf)) {
      final var select = nd.getAttributes()
                           .getNamedItem("select")
                           .getNodeValue();

      final var variable = vars.variables.get(select);
      if (variable != null) {
        variable.setReferenced(true);
      }
      return;
    }

    for (final var child: XmlUtil.getNodes(xsl)) {
      matchVariables(child, vars);
    }
  }

  public void showUnreffed() {
    if (!defaultStrings) {
      return;
    }

    for (final var v: variables.values()) {
      if (v.isReferenced()) {
        continue;
      }

      info("Unreffed " + v.name + ": \"" + v.value + "\"");
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
