# Folder Actions

System process to watch folders and take actions when files appear or are changed in a folder.

## Usage

Run the executable with a config:

```bash
bin/folder_actions start --config path/to/config.yml
```

You can pass many configs:
```bash
bin/folder_actions start --config path/to/config.yml --config path/to/other/config.yml
```

You can validate configs:
```bash
bin/folder_actions validate --config path/to/other/config.yml
```


## Configuration Files

### YAML

A YAML config file contains a root element of `entries:` which is an array, each containing an entry.

Keys may be:

* `path`: Path to the folder to watch, or an array of paths to watch.
* `operation`: The file action to watch, `create` `update`. (Note: I wanted to call this `on` but that evaluates to `true` in YAML 🙃)
* `notification`: System notification as a string.
* `file_pattern`: String matcher for the file. This is what would match a _glob_ in shell, not a regex.
* `delete_original`: Boolean if the original file should be deleted after the action.
* `command`: String executed.
* `action_class`: A class in the project that performs the folder action.
* `arguments`: Args passed to the construcor for the above class.


Handlebar templates are used to interpolate the following strings:

* `{{file_name}}`: The name of the file without the path.
* `{{file_path}}`: The full path of the file.
