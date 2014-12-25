# dmail

Command-line email client.

## Installation

    $ gem install dmail

## Setup

dmail reads settings firstly from ''.dmailrc.yaml'' and fallbacks to ''~/.dmailrc.yaml''.

Gmail setup:

``` yaml
dmail:
  reading:
    method: imap
    address: imap.gmail.com
    port: 993
    enable_ssl: true
    user_name: me@gmail.com
    password: myp4ssw0rd
```

## Usage

Listing emails:

```
$ dmail list

```

Viewing emails:

```
$ dmail show CAC0GtHcR13bnhLju=DymZm0fr778LALHw3HwWUVXrM81c4Hc+Q@mail.gmail.com
```

## Contributing

You're encouraged to submit issues, PRs and weigh in your opinion anywhere. If you want to get started,
feel free to contact the authors either directly or through a new issue. We also love documentation so
feel free to extend this README.

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2014 André Dieb Martins
