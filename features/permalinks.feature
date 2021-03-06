Feature: Page Permalinks
  As a content publisher
  I want to customize the permalinks to my pages
  so that my site is organized and can be accessed in an optimized way.

  Scenario: Default Permalink format
    Given some files with values:
    | file              | body |
    | essays/hello.md   |      |
    When I compile my site
    Then my compiled site should have the file "essays/hello/index.html"

  Scenario: Default Permalink format with nested file
    Given some files with values:
    | file              | body |
    | essays/one/two/hello.md   |      |
    When I compile my site
    Then my compiled site should have the file "essays/one/two/hello/index.html"

# in-page configuration

  Scenario: Custom permalink format in page metadata.
    Given some files with values:
    | file              | permalink | body |
    | essays/hello.md   | /yay/:path/:filename | |
    When I compile my site
    Then my compiled site should have the file "yay/essays/hello/index.html"

  Scenario: Custom permalink format in page metadata using relative path.
    Given some files with values:
    | file              | permalink | body |
    | essays/hello.md   | /:relative_path/:filename | |
    When I compile my site
    Then my compiled site should have the file "hello/index.html"

  Scenario: Custom permalink format in page metadata using title.
    Given some files with values:
    | file              | permalink | title | body |
    | essays/hello.md   | /:path/:title | Haro World | |
    When I compile my site
    Then my compiled site should have the file "essays/haro-world/index.html"

  Scenario: Custom permalink format in page metadata using categories.
    Given some files with values:
    | file              | permalink | categories | body |
    | essays/hello.md   | /:path/:categories/:filename | random stuff | |
    When I compile my site
    Then my compiled site should have the file "essays/random-stuff/hello/index.html"

  Scenario: Custom permalink format in page metadata using date.
    Given some files with values:
    | file              | permalink | date | body |
    | essays/hello.md   | /:path/:year/:month/:day/:filename | 2012-01-12 | |
    When I compile my site
    Then my compiled site should have the file "essays/2012/01/12/hello/index.html"

  Scenario: Custom permalink format in page metadata using date with integer format.
    Given some files with values:
    | file              | permalink | date | body |
    | essays/hello.md   | /:path/:year/:i_month/:i_day/:filename | 2012-01-02 | |
    When I compile my site
    Then my compiled site should have the file "essays/2012/1/2/hello/index.html"

  Scenario: Custom permalink format in page metadata using custom metadata attributes.
    Given some files with values:
    | file              | permalink | title | arbitrary_name | body |
    | essays/hello.md   | /:path/:title/:arbitrary_name | Haro World | custom data | |
    When I compile my site
    Then my compiled site should have the file "essays/haro-world/custom-data/index.html"

  Scenario: Custom permalink format in page metadata using explicit html extension
    Given some files with values:
    | file              | permalink      |
    | essays/hello.md   | :filename.html |
    When I compile my site
    Then my compiled site should have the file "hello.html"

  Scenario: Custom permalink format in page metadata using explicit convertable extension
    Given some files with values:
    | file              | permalink      |
    | essays/hello.md   | :filename.md   |
    When I compile my site
    Then my compiled site should have the file "hello.md"

  Scenario: Custom permalink format in page metadata using explicit arbitrary extension
    Given some files with values:
    | file              | permalink      |
    | essays/hello.md   | :filename.derp |
    When I compile my site
    Then my compiled site should have the file "hello.derp"

## Literal permalink

  Scenario: Literal permalink format in page metadata.
    Given some files with values:
    | file              | permalink | body |
    | essays/hello.md   | /literal-page-permalink | |
    When I compile my site
    Then my compiled site should have the file "literal-page-permalink/index.html"

## Collection configuration

  Scenario: Custom permalink format in collection config.
    Given a config file with values:
      | essays | { "permalink" : "/yay/:path/:filename" } |
      And some files with values:
        | file              | body |
        | essays/hello.md   | |
    When I compile my site
    Then my compiled site should have the file "yay/essays/hello/index.html"

  Scenario: Custom permalink format in collection config using relative path.
    Given a config file with values:
      | essays | { "permalink" : "/:relative_path/:filename" } |
      And some files with values:
      | file              | body |
      | essays/hello.md   | |
    When I compile my site
    Then my compiled site should have the file "hello/index.html"

  Scenario: Custom permalink format in collection config using title.
    Given a config file with values:
      | essays | { "permalink" : "/:path/:title" } |
      And some files with values:
      | file              | title | body |
      | essays/hello.md   | Haro World | |
    When I compile my site
    Then my compiled site should have the file "essays/haro-world/index.html"

  Scenario: Custom permalink format in collection config using categories.
    Given a config file with values:
      | essays | { "permalink" : "/:path/:categories/:filename" } |
      And some files with values:
      | file              | categories | body |
      | essays/hello.md   | random stuff | |
    When I compile my site
    Then my compiled site should have the file "essays/random-stuff/hello/index.html"

  Scenario: Custom permalink format in collection config using date.
    Given a config file with values:
      | essays | { "permalink" : "/:path/:year/:month/:day/:filename" } |
      And some files with values:
      | file              | date | body |
      | essays/hello.md   | 2012-01-12 | |
    When I compile my site
    Then my compiled site should have the file "essays/2012/01/12/hello/index.html"

  Scenario: Custom permalink format in collection config using date with integer format.
    Given a config file with values:
      | essays | { "permalink" : "/:path/:year/:i_month/:i_day/:filename" } |
      And some files with values:
      | file              | date | body |
      | essays/hello.md   | 2012-01-02 | |
    When I compile my site
    Then my compiled site should have the file "essays/2012/1/2/hello/index.html"

  Scenario: Custom permalink format in collection config using custom metadata
    Given a config file with values:
      | essays | { "permalink" : "/legacy/:custom_id/:rank" } |
      And some files with values:
      | file              | custom_id | rank | body |
      | essays/hello.md   | 12345 | medium | |
    When I compile my site
    Then my compiled site should have the file "legacy/12345/medium/index.html"
