# 安装与同步（B-PROMPT）

## 源与副本

| 角色 | 路径 |
|---|---|
| **源（唯一权威，改这里）** | `<源目录>`（本机：`D:\Hermes\work\skills\b-prompt\`） |
| Hermes 副本 | `%LOCALAPPDATA%\hermes\skills\<分类>\b-prompt\`（Linux/macOS：`~/.local/share/hermes/skills/...`） |
| Claude Code 副本 | `~/.claude/skills/b-prompt/` |
| pi 副本 | `~/.pi/agent/skills/b-prompt/` |
| Cursor 副本 | `~/.cursor/skills/b-prompt/` |

四个副本内容**逐字节相同**，只读取源、不反向同步。改完跑一次 `sync.sh`（Windows 用 git-bash 或 WSL；也可以手动复制这三个文件）。

## 手动安装（任何支持 SKILL.md 的 agent）

把 `b-prompt/` 整个目录复制到该 agent 的 skill 目录下即可。若某 agent 不支持 skill 目录：

- 支持 `@文件引用` 的（多数 CLI）：把 `SKILL.md` 内容作为系统提示词的一部分注入，或随消息引用该文件。
- 只有单一系统提示词的：把 `SKILL.md` 正文（frontmatter 之后的部分）粘进系统提示词。注意这会常驻上下文，删掉「参考」一节可省 token。

## 格式要求（各 agent 的差异）

- **必填**：`name`（小写字母/数字/连字符，≤64 字符）+ `description`。四家都满足。
- **额外字段**：`version` / `author` / `license` / `platforms` / `metadata` 属于扩展字段，不认识的 agent 会忽略。
- **name 必须与目录名一致**（Claude Code 的约定，pi / Cursor 同样按目录名或 name 索引）。
- `description` 是**唯一的自动发现入口**：写清触发词，不要写能力介绍。本 skill 的触发词是「优化这个提示词」。

## 兼容性证据

| Agent | 加载位置 | 依据 |
|---|---|---|
| Claude Code | `~/.claude/skills/<name>/SKILL.md` | 实测（本机已有多个同结构 skill，含 `references/`、`scripts/` 子目录） |
| pi | `~/.pi/agent/skills/<name>/SKILL.md` | 实测（本机 skill 目录结构与 frontmatter 已确认） |
| Cursor | `~/.cursor/skills/<name>/SKILL.md` | 实测（目录与文件结构已确认）；**未做端到端调用测试**（本机无 Cursor 无头 CLI） |
| Hermes | `%LOCALAPPDATA%\hermes\skills\<分类>\<name>\SKILL.md` | 实测（本 skill 已安装并成功加载） |

## 校验

```
# 副本一致性（四个位置应全部 OK）
for d in <各副本目录>; do diff -r "<源目录>" "$d" && echo "OK $d"; done

# frontmatter 合法性
head -8 SKILL.md
```

## 升级

改源目录 → 跑 `sync.sh` → 重跑上面的校验。**不要直接改副本**，下次同步会被覆盖。
