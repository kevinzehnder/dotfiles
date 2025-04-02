# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Style Guidelines

### General
- Maintain consistent indentation (2 spaces for JSON/YAML, tabs for Lua)
- Follow existing naming conventions in each config file
- Keep code organized in logical sections with comments
- Preserve existing comment style in each file

### JavaScript/TypeScript
- Use double quotes for strings
- Include trailing commas
- Maximum line length of 100 characters
- Tab width of 2 spaces

### Lua
- Use double quotes for strings
- Indentation: 2 spaces (or follow file-specific settings)
- Column width: 120 characters
- No parentheses for function calls

### YAML
- Include document start marker (---)
- Retain existing line breaks
- Follow consistent indentation (2 spaces)

## Commands
- Check shell scripts: `shellcheck <filename>`
- Format YAML: `yamlfmt <filename>`
- Format Lua: `stylua <filename>`
- Format JS/TS: `prettier --write <filename>`

## Error Handling
- For shell scripts, use proper error checking with exit codes
- For configuration files, ensure valid syntax before saving