package org.bedework.calendarXsl.checkStrings;

import org.bedework.base.exc.BedeworkException;
import org.bedework.util.logging.BwLogger;
import org.bedework.util.logging.Logged;
import org.bedework.util.xml.FromXml;
import org.bedework.util.xml.XmlUtil;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
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

  final static QName xslValueOf =
      new QName(nsXSL, "value-of");

  final static QName xslWithParam =
      new QName(nsXSL, "with-param");

  final static QName htmlA =
      new QName(null, "a");

  final static QName htmlImg =
      new QName(null, "img");

  final static QName htmlTextArea =
      new QName(null, "textarea");

  final static QName htmlTable =
      new QName(null, "table");

  final static QName htmlSelect =
      new QName(null, "select");

  final static QName htmlInput =
      new QName(null, "input");

  final Path path;
  final Document xsl;
  final Element root;
  final boolean isStylesheet;
  final boolean isStringsXsl;
  final boolean defaultStrings;

  long noSelect;
  long noTitle;

  long unreffedCount;

  final Map<String, XslVariable> variables = new HashMap<>();

  public XslFile(final Path path) {
    this.path = path;
    isStringsXsl = path.endsWith("strings.xsl");
    defaultStrings = path.endsWith("webapp/default/strings.xsl");
    try {
      xsl = FromXml.parseXml(new FileReader(path.toFile()));
    } catch (final FileNotFoundException e) {
      throw new BedeworkException(e);
    }

    root = xsl.getDocumentElement();
    // Root should be xsl:stylesheet
    if (!XmlUtil.nodeMatches(root, xslStylesheet)) {
      isStylesheet = false;
      return;
    }

    isStylesheet = true;

    if (!isStringsXsl) {
      return;
    }

    for (final var nd: XmlUtil.getNodes(root)) {
      if (!XmlUtil.nodeMatches(nd, xslVariable)) {
        continue;
      }
      final var name = nd.getAttributes()
                         .getNamedItem("name")
                         .getNodeValue();
      variables.put(name,
                    new XslVariable(name,
                                    nd.getTextContent()));
    }
  }

  public void matchVariables(final XslFile vars) {
    for (final var nd: XmlUtil.getNodes(root)) {
      matchVariables(nd, vars);
    }
  }

  private void matchSelect(final Node nd,
                           final XslFile vars) {
    matchAttr(nd, vars, "select");
  }

  private void matchAlt(final Node nd,
                        final XslFile vars) {
    matchAttr(nd, vars, "alt");
  }

  private void matchTitle(final Node nd,
                          final XslFile vars) {
    matchAttr(nd, vars, "title");
  }

  private void matchValue(final Node nd,
                          final XslFile vars) {
    matchAttr(nd, vars, "value");
  }

  private void matchPlaceholder(final Node nd,
                                final XslFile vars) {
    matchAttr(nd, vars, "placeholder");
  }

  private void matchAttr(final Node nd,
                         final XslFile vars,
                         final String attrName) {
    final var attr = nd.getAttributes()
                       .getNamedItem(attrName);
    if (attr == null) {
      return;
    }

    final var val = attr.getNodeValue();
    final String trimVal;

    if (val.startsWith("{$") && val.endsWith("}")) {
      trimVal = val.substring(2, val.length() - 1);
    } else if (val.startsWith("$")) {
      trimVal = val.substring(1);
    } else {
      return;
    }

    final var variable = vars.variables.get(trimVal);
    if (variable != null) {
      variable.setReferenced(true);
    }
  }

  private void matchVariables(final Node nd,
                              final XslFile vars) {
    if (XmlUtil.nodeMatches(nd, xslCopyOf)) {
      matchSelect(nd, vars);
      return;
    }

    if (XmlUtil.nodeMatches(nd, xslValueOf)) {
      matchSelect(nd, vars);
      return;
    }

    if (XmlUtil.nodeMatches(nd, xslWithParam)) {
      matchSelect(nd, vars);
      return;
    }

    if (XmlUtil.nodeMatches(nd, htmlA)) {
      matchTitle(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlImg)) {
      matchAlt(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlSelect)) {
      matchTitle(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlTable)) {
      matchTitle(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlTextArea)) {
      matchPlaceholder(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlInput)) {
      matchValue(nd, vars);
      matchPlaceholder(nd, vars);
    }

    final var children = nd.getChildNodes();

    for (int i = 0; i < children.getLength(); i++) {
      final var child = children.item(i);
      if (child.getNodeType() == Node.ELEMENT_NODE) {
        matchVariables(child, vars);
      }
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

      unreffedCount++;
      info("Unreffed " + v.name + ": \"" + v.value + "\"");
    }
  }

  public long getNoSelect() {
    return noSelect;
  }

  public long getUnreffedCount() {
    return unreffedCount;
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
