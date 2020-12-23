# Pico Database

_A primitive file-based set supporting CRUD operations._

This small tool serves as a minimal file-based persistent unique key database supporting CRUD operations on the key. Assuming infrequent access by a single application, there's no file locking.

Many applications implement this on their own (and usually within a few lines with `grep`); by delegating to this tool, one gets a robust yet small implementation, consistency in usage and storage locations, and the possibility to easily upgrade to the more powerful yet similar [`nanoDB`](https://github.com/inkarkat/nanoDB) and [`miniDB`](https://github.com/inkarkat/miniDB) APIs.

Each database "table" is represented as an individual file (put by default under `~/.local/share/[NAMESPACE/]TABLE`, the location can be customized via command-line arguments or `$XDG_DATA_HOME`). Each record is a line consisting of a newline-escaped KEY (so newlines and any other special character can be used). Keys can be queried separately for existence, or the whole database can be gotten, either as the lines (newlines have to be unescaped by the client) or as a Bash associative array definition that can be `eval`'ed into existence and then tested for keys.

## Dependencies

* Bash, `grep`, GNU `sed`
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)
