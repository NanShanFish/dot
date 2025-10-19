#!/usr/bin/env python3

import os
import subprocess
import toml
from pathlib import Path
import argparse

BASE_DIR = Path(os.getenv('XDG_CONFIG_HOME', os.path.expanduser('~/.config')) + "/styleman")
MODEL_FILE = BASE_DIR / "model.toml"
PALETTE_DIR = BASE_DIR / "palette"
TEMPLATE_DIR = BASE_DIR / "template"

def list_themes():
    print("AVLIABLE THEMES:")
    for f in PALETTE_DIR.glob("*.toml"):
        print(f"\t{f.stem}")

def check_theme(theme: str):
    theme_file = PALETTE_DIR / f"{theme}.toml"
    if not theme_file.exists():
        exit(f"[ERROR] theme '{theme}' not exist")

    try:
        model = toml.load(MODEL_FILE)
    except Exception as e:
        exit(f"[ERROR] error when load model.toml: {e}")

    for module, config in model.items():
        required = ["template", "target"]
        for field in required:
            if field not in config:
                exit(f"[ERROR] The module '{module}' is missing required field '{field}'.")

        tpl_path: Path = TEMPLATE_DIR / config["template"]
        if not tpl_path.exists():
            print(f"[WARN] template file {tpl_path} not exist")
    print(f"[INFO] {theme}'s configuration file is complete")

def select_theme(theme: str, modules: list[str] = None):
    theme_file = PALETTE_DIR / f"{theme}.toml"
    variables = toml.load(theme_file)

    model = toml.load(MODEL_FILE)

    modules_to_process = {}
    if modules:
        invalid_modules = [m for m in modules if m not in model]
        if invalid_modules:
            exit(f"[ERROR] Undefine modules {', '.join(invalid_modules)}")
        modules_to_process = {m: model[m] for m in modules}
    else:
        modules_to_process = model

    for module, config in modules_to_process.items():
        print(f"[INFO] Process module {module}...")

        tpl_path: Path = TEMPLATE_DIR / config["template"]
        target_path = Path(os.path.expanduser(config["target"]))

        if "prefix" in config and config["prefix"]:
            print(f"    ==> running prefix: {config['prefix']}")
            subprocess.run(config['prefix'], shell=True, check=True)

        if tpl_path.exists():
            content = tpl_path.read_text()
            for var, value in variables.items():
                content = content.replace(f"{{{{ {var} }}}}", value)

            target_path.parent.mkdir(parents=True, exist_ok=True)
            target_path.write_text(content)
            print(f"    ==> spawn file: {target_path}")
        else:
            print(f"[WARN] Skip the non-existent template {tpl_path}")

        if 'suffix' in config and config['suffix']:
            print(f"    ==> running suffix: {config['suffix']}")
            subprocess.run(config['suffix'], shell=True, check=True)

    print(f"\n[INFO] theme '{theme}' has been applied")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="theme config file manager")
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("list", help="List all avliable themes")

    check_parser = subparsers.add_parser("check", help="Check the integrity of the theme")
    check_parser.add_argument("theme", help="theme name")

    select_parser = subparsers.add_parser("select", help="Apply theme")
    select_parser.add_argument("theme", help="theme name")
    select_parser.add_argument("-m", "--modules", 
                            type=lambda s: [m.strip() for m in s.split(',')],
                            help="modules name, split by ','")
    args = parser.parse_args()

    match args.command:
        case "list":
            list_themes()
        case "check":
            check_theme(args.theme)
        case "select":
            select_theme(args.theme, args.modules)
        case _:
            parser.print_help()
