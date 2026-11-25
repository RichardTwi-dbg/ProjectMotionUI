import re
from pathlib import Path

SOURCE_DIR = Path("media/lua/client/ProjectMotionUI")

CLASS_PATTERN = re.compile(r"^(PMUI\.[A-Za-z0-9_]+)\s*=\s*([A-Za-z0-9_.]+):derive\(")
FUNC_PATTERN = re.compile(r"^function\s+(PMUI(?:\.[A-Za-z0-9_]+)+[:.][A-Za-z0-9_]+)\s*\(([^)]*)\)")


def parse_lua_file(filepath: Path):
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    classes = []
    functions = []
    comment_buffer = []

    for line in lines:
        stripped = line.strip()

        if stripped.startswith("--"):
            clean_comment = stripped.lstrip("-").strip()
            comment_buffer.append(clean_comment)
            continue

        class_match = CLASS_PATTERN.match(stripped)
        if class_match:
            classes.append({
                "name": class_match.group(1),
                "parent": class_match.group(2),
                "docs": list(comment_buffer)
            })
            comment_buffer.clear()
            continue

        func_match = FUNC_PATTERN.match(stripped)
        if func_match:
            full_name = func_match.group(1)
            args = func_match.group(2).strip()
            functions.append({
                "name": full_name,
                "args": args,
                "docs": list(comment_buffer)
            })
            comment_buffer.clear()
            continue

        if stripped != "":
            comment_buffer.clear()

    return classes, functions


def format_doc_lines(doc_lines, labels):
    desc = []
    params = []
    for line in doc_lines:
        if line.startswith("@param"):
            parts = line.replace("@param", "").strip().split(" ", 2)
            p_name = parts if len(parts) > 0 else ""
            p_type = parts if len(parts) > 1 else ""
            p_desc = parts if len(parts) > 2 else ""
            params.append(f"| `{p_name}` | `{p_type}` | {p_desc} |")
        else:
            desc.append(line)

    md = ""
    if desc:
        md += "\n".join(desc) + "\n\n"
    if params:
        md += f"| {labels['param']} | {labels['type']} | {labels['desc']} |\n| :--- | :--- | :--- |\n"
        md += "\n".join(params) + "\n\n"
    return md


def build_locale_docs(output_dir: Path, url_prefix: str, labels: dict):
    output_dir.mkdir(parents=True, exist_ok=True)
    sidebar_items = []

    for lua_file in sorted(SOURCE_DIR.rglob("*.lua")):
        if "Examples" in lua_file.parts:
            continue

        classes, functions = parse_lua_file(lua_file)
        if not classes and not functions:
            continue

        rel_path = lua_file.relative_to(SOURCE_DIR)
        md_name = rel_path.with_suffix(".md").name
        out_file = output_dir / md_name

        content = [f"# {lua_file.stem}\n"]
        content.append(f"**{labels['req']}:** `require \"ProjectMotionUI/{rel_path.with_suffix('').as_posix()}\"`\n\n---\n")

        for cls in classes:
            content.append(f"## {labels['cls']} `{cls['name']}`\n")
            content.append(f"*{labels['inh']}:* `{cls['parent']}`\n\n")
            content.append(format_doc_lines(cls["docs"], labels))

        if functions:
            content.append(f"## {labels['methods']}\n\n")
            for fn in functions:
                content.append(f"### `{fn['name']}({fn['args']})`\n\n")
                content.append(format_doc_lines(fn["docs"], labels))

        with open(out_file, "w", encoding="utf-8") as f:
            f.write("".join(content))

        sidebar_items.append((lua_file.stem, f"{url_prefix}/{lua_file.stem}"))

    index_md = [f"# {labels['idx_title']}\n\n{labels['idx_sub']}\n\n## {labels['modules']}\n\n"]
    for title, link in sidebar_items:
        index_md.append(f"- [{title}]({link}.md)\n")

    with open(output_dir / "index.md", "w", encoding="utf-8") as f:
        f.write("".join(index_md))


if __name__ == "__main__":
    en_labels = {
        "req": "Require path",
        "cls": "Class",
        "inh": "Inherits from",
        "methods": "Methods & Functions",
        "param": "Parameter",
        "type": "Type",
        "desc": "Description",
        "idx_title": "PMUI API Reference",
        "idx_sub": "Auto-generated documentation for all framework classes and methods.",
        "modules": "Modules"
    }
    ru_labels = {
        "req": "Путь подключения",
        "cls": "Класс",
        "inh": "Наследуется от",
        "methods": "Методы и функции",
        "param": "Параметр",
        "type": "Тип",
        "desc": "Описание",
        "idx_title": "Справочник API PMUI",
        "idx_sub": "Автоматически сгенерированная документация по всем классам и методам фреймворка.",
        "modules": "Модули"
    }

    build_locale_docs(Path("docs/api"), "/api", en_labels)
    build_locale_docs(Path("docs/ru/api"), "/ru/api", ru_labels)
