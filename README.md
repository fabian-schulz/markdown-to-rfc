# Markdown-to-RFC Converter

This repository provides a simple docker image and Makefile, that allows to automatically build RFC's (as PDF, HTML and TXT) without worrying about the underlying tools.
It uses xml2rfc and kramdownrfc to create these RFCs.

## Using Makefile

Run `make <target>` inside the directory or run `make` to create RFCs for all files and filetypes.

## TODO's

- Add sample markdown file in RFC syntax
