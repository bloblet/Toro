# Guidlines for contributing

## Modifying `pubspec.yaml`
Do:
- Follow the implied format in the pubspec
- Add an explaining comment of what the package is.

## Adding an import in a file
Do:
- Put dart imports at the top
- Put package imports next
- Then put any imports to other directories, `import './models/user.dart`
- Then put any same folder imports.

Don't:
- Do package imports to our own package
- Prefix same folder imports with `.`
- Use double quotes on imports

## Making widgets
Do:
- Add commas after every ending )