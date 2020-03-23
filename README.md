# bw-calendar-xsl

This project provides a deployable set of stylesheets for 
[Bedework](https://www.apereo.org/projects/bedework).

Deployers should copy this project into their own repository and deploy their own version.

## Requirements

1. JDK 11
2. Maven 3

## Building Locally

> mvn clean install

## Releasing

Releases of this project are published to Maven Central via Sonatype.

To create a release, you must have:

1. Permissions to publish to the `org.bedework` groupId.
2. `gpg` installed with a published key (release artifacts are signed).

To perform a new release:

> mvn -P bedework-dev release:clean release:prepare

When prompted, select the desired version; accept the defaults for scm tag and next development version.
When the build completes, and the changes are committed and pushed successfully, execute:

> mvn -P bedework-dev release:perform

For full details, see [Sonatype's documentation for using Maven to publish releases](http://central.sonatype.org/pages/apache-maven.html).

## Release Notes
### 3.12.1 
  * First real release.

### 3.12.2 
  * Fix jsonTz to use new form of expand.
  * Prefix hrefs with /approot

### 3.12.3 
  * Copy in location and contact search for admin client. Also location/contact changes for main client.

### 3.12.4
    * No changes 

### 3.12.5
    * No changes 

### 3.13.0 
  * Less noise in logs.

### 3.13.1 
  * Use combined values from location and implement NO-LINK for map urls.
  * change | operator to "or"

### 3.13.2 
  * Add single page submission client theme.
  * Fix update/add locations in user client
  * Add all the extra fields to the user client. Still need to fix styles
  * Fix up location styles in user client
  * Arlen updates for featured events.
  

   