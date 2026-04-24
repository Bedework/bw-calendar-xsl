package org.bedework.calendarXsl.checkStrings;

public class XslVariable {
  final String name;
  final String value;

  boolean referenced;

  XslVariable(final String name,
              final String value) {

    this.name = name;
    this.value = value;
  }

  public String getName() {
    return name;
  }

  public String getValue() {
    return value;
  }

  public boolean isReferenced() {
    return referenced;
  }

  public void setReferenced(final boolean referenced) {
    this.referenced = referenced;
  }
}
