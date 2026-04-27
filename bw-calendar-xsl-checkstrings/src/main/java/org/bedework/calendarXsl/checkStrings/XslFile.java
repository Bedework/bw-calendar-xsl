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

  final static String nsHTML =
      "http://www.w3.org/1999/xhtml";

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
      new QName(nsHTML, "a");

  final static QName htmlArea =
      new QName(nsHTML, "area");

  final static QName htmlDiv =
      new QName(nsHTML, "div");

  final static QName htmlImg =
      new QName(nsHTML, "img");

  final static QName htmlTextArea =
      new QName(nsHTML, "textarea");

  final static QName htmlTable =
      new QName(nsHTML, "table");

  final static QName htmlSelect =
      new QName(nsHTML, "select");

  final static QName htmlInput =
      new QName(nsHTML, "input");

  final Path path;
  final Document xsl;
  final Element root;
  final boolean isStylesheet;
  final boolean isStringsXsl;
  final boolean defaultStrings;

  long noSelect;
  long noTitle;

  long unreffedCount;

  boolean traceInput;

  final Map<String, XslVariable> variables = new HashMap<>();

  public XslFile(final Path path) {
    this.path = path;
    isStringsXsl = path.endsWith("strings.xsl");
    defaultStrings = path.endsWith("webapp/default/strings.xsl");
    traceInput = path.endsWith("webapp/themes/bedeworkTheme/searchResults.xsl");
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

  private boolean matchSelect(final Node nd,
                              final XslFile vars) {
    return matchAttr(nd, vars, "select");
  }

  private boolean matchAlt(final Node nd,
                           final XslFile vars) {
    return matchAttr(nd, vars, "alt");
  }

  private boolean matchName(final Node nd,
                            final XslFile vars) {
    return matchAttr(nd, vars, "name");
  }

  private boolean matchTitle(final Node nd,
                             final XslFile vars) {
    return matchAttr(nd, vars, "title");
  }

  private boolean matchValue(final Node nd,
                             final XslFile vars) {
    return matchAttr(nd, vars, "value");
  }

  private boolean matchPlaceholder(final Node nd,
                                   final XslFile vars) {
    return matchAttr(nd, vars, "placeholder");
  }

  private boolean matchAttr(final Node nd,
                            final XslFile vars,
                            final String attrName) {
    final var attr = nd.getAttributes()
                       .getNamedItem(attrName);
    if (attr == null) {
      return false;
    }

    final var val = attr.getNodeValue();
    final String trimVal;

    if (val.startsWith("{$") && val.endsWith("}")) {
      trimVal = val.substring(2, val.length() - 1);
    } else if (val.startsWith("$")) {
      trimVal = val.substring(1);
    } else {
      return false;
    }

    final var variable = vars.variables.get(trimVal);
    if (variable != null) {
      variable.setReferenced(true);
      return true;
    }

    return false;
  }

  private boolean hasAttr(final Node nd,
                          final String attrName,
                          final String val) {
    final var attr = nd.getAttributes()
                       .getNamedItem(attrName);
    if (attr == null) {
      return false;
    }

    return val.equals(attr.getNodeValue());
  }

  private boolean matchOnclick(final Node nd,
                               final XslFile vars) {
    final var attr = nd.getAttributes()
                       .getNamedItem("onclick");
    if (attr == null) {
      return false;
    }

    final var val = attr.getNodeValue();

    if (val == null) {
      return false;
    }

    var matched = false;
    int st = val.indexOf("{$");
    while (st >= 0) {
      final var end = val.indexOf("}", st);
      if (end == -1) {
        return matched;
      }

      final var variable = vars.variables.get(
          val.substring(st + 2, end));
      if (variable != null) {
        variable.setReferenced(true);
        matched = true;
      }
      st = val.indexOf("{$", end);
    }

    return matched;
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

    if (XmlUtil.nodeMatches(nd, htmlDiv) &&
        hasAttr(nd, "id", "bwEventTab-Recurrence")) {
      debug("Found");
    }

    matchName(nd, vars);
    matchTitle(nd, vars);
    matchValue(nd, vars);
    matchOnclick(nd, vars);

    if (XmlUtil.nodeMatches(nd, htmlImg)) {
      matchAlt(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlTextArea)) {
      matchPlaceholder(nd, vars);
    } else if (XmlUtil.nodeMatches(nd, htmlInput)) {
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
