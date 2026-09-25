# b-prompt · B-PROMPT 提示词优化

一个**跨 agent 通用**的提示词优化 skill：把模糊、缺信息的自然语言指令，改写成目标明确、输入清晰、结构一目了然的提示词。

**核心纪律：只优化，不执行。** 原提示词里描述的业务任务（写文件、删数据、发消息、跑脚本）一律不做 —— 产出是文本，不是执行结果。

适用于任何支持 `SKILL.md` 的 agent（Claude Code / Cursor / pi / Hermes / 其它），已在本机四端实测装载。

## 两种模式

| 触发 | 模式 | 产出 |
|---|---|---|
| 「优化这个提示词」「帮我改提示词」 | **B · 优化** | 固定四模块：问题诊断（带评分）/ 优化后提示词 / 已做假设 / 关键追问 |
| 「再改一版，往 X 方向」 | **B · 迭代** | 四模块 + `v2 · 目标：<goal>` 版本头 |
| 「把我这句转成提示词」「出个提示词卡」 | **A · 转换** | 5 行提示词卡（目标/输入/产出/边界）+ 停手等确认 |

**默认关闭，仅显式触发** —— 不对普通指令自动出卡，不主动提议「要不要帮你优化成提示词」。

## 两条铁律

1. **只优化，不执行。**
2. **不虚构关键事实。** 信息不足允许合理假设，但假设必须显式写进「已做假设」；关键事实编不出来就留占位符 + 追问。

## 安装

把整个 `b-prompt/` 目录复制到对应 agent 的 skill 目录即可：

| Agent | 路径 |
|---|---|
| Claude Code | `~/.claude/skills/b-prompt/` |
| Cursor | `~/.cursor/skills/b-prompt/` |
| pi | `~/.pi/agent/skills/b-prompt/` |
| Hermes | `%LOCALAPPDATA%\hermes\skills\<分类>\b-prompt\`（Linux/macOS：`~/.local/share/hermes/skills/…`） |

不支持 skill 目录的 agent：把 `SKILL.md` 中 frontmatter 之后的部分粘进系统提示词即可（会常驻上下文，可删掉「参考」一节省 token）。

细节见 [`INSTALL.md`](INSTALL.md)；多副本同步用 [`sync.sh`](sync.sh)。**装好后需新开会话**，skill 索引在会话启动时构建。

## 文件

```
b-prompt/
├─ SKILL.md                  主文件：触发条件、两模式流程、禁止事项、验证清单
├─ INSTALL.md                各 agent 的落盘位置、格式差异、兼容性证据
├─ sync.sh                   源 → 多副本同步（只增改，不删除）
└─ references/
   ├─ lyra-rubric.md         提示词类型分流、优化级别、评分五维、迭代目标、接收方适配
   └─ examples.md            四个实例：出卡 / 简单任务不硬拆 / 复杂多阶段拆步 / system prompt
```

## 设计来源

- 元提示词骨架：固定四模块输出、禁执行业务任务、假设显式、追问 ≤3 带选项。
- [Lyra Prompt Optimizer](https://lyraprompt.com/prompt-optimizer) 的机制：提示词类型分流（user / system）、优化级别（basic / advanced / expert）、五维评分、迭代目标枚举（`enhance_clarity` / `improve_structure` / `refine_specificity` / `add_examples` / `general_improvement`）。

## 设计取舍

- **默认 `basic` 级别**，不默认 expert —— 简单任务拆六步等于没优化。
- **简单任务不硬拆**：单步单产出保持 3–8 行，维持原语气。
- **复杂任务拆步**：多产出 / 多阶段 / 需验收的，拆成编号步骤，每步带验收标准与输出格式。
- **评分并入模块 1**，不新增模块 —— 输出严格保持四模块。

## License

MIT © 21671 (BJC666)
