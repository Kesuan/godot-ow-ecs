# Godot OW ECS

用 Godot 研究实体组件系统（ECS），并用同一套框架迭代原创英雄和技能。研究起点是 Timothy Ford 在 GDC 2017 对《守望先锋》玩法架构的公开讲解。仓库里的代码是我们在 Godot 中做的实验。[观看 GDC 演讲](https://gdcvault.com/play/1024001/-Overwatch-Gameplay-Architecture-and)

同一段系统代码能否驱动冷却时长不同的英雄？在第一个实验中，你可以在主场景手动触发一次脉冲，也可以在无窗口测试里让两个英雄同时进入冷却，观察它们何时可以再次施放。

## 运行第一个实验

1. 安装 **Godot 4.7.2 标准版**。项目使用 GDScript 和 Compatibility 渲染器，无需额外插件。
2. 在 Godot 项目管理器导入根目录的 `project.godot`，打开后按 **F5** 运行主场景。
3. 点击 **Activate pulse**。按钮进入冷却，充能条在 3 秒内填满，随后按钮恢复可用。
4. 打开 `game/hero_lab/hero_lab.tscn`，选中根节点，把检查器中的 **Cooldown Seconds** 改为 `1.0`。重新运行，比较两次冷却的时长。

命令行中可从仓库根目录执行以下检查。`godot` 表示 Godot 4.7.2 可执行文件。在 Windows 上也可以用 PowerShell 的 `& "引擎完整路径"` 替代它。

```sh
godot --headless --path . --import
godot --headless --path . --quit-after 10
godot --headless --path . --script res://tests/cooldown_smoke.gd
```

最后一条命令会输出 `PASS: cooldown smoke test` 并以状态码 0 退出。

## 从哪里读代码

| 入口 | 值得观察的地方 |
| --- | --- |
| [World](addons/ow_ecs/world.gd) | 实体是 World 内的整数 ID。World 按实体 ID 和组件脚本保存组件实例，系统可以查询持有某种组件的实体。 |
| [Cooldown 组件](game/components/cooldown.gd) | 每个实例保存冷却总时长和剩余秒数。两个英雄可以有不同的数值。 |
| [Cooldown 系统](game/systems/cooldown_system.gd) | `try_activate` 检查一次施放请求，`tick` 按给定的时间步长推进所有冷却。 |
| [英雄实验场](game/hero_lab/hero_lab.gd) | 场景创建实体并接收按钮输入。每个物理帧先推进冷却，再处理施放请求，最后把组件状态画出来。 |
| [无窗口测试](tests/cooldown_smoke.gd) | 直接推进 1.25 秒，检查短冷却归零、长冷却剩余 1.75 秒，以及移除实体后的查询结果。 |
| [研究笔记](docs/research/ecs-basics.md) | 从公开资料中的问题出发，对照实验代码，记录观察结果和下一步问题。 |

## 后续迭代

下一步可以给同一个英雄配置两个独立技能。当前一个实体只能持有一个同类型组件。让英雄持有多个冷却槽，或让每个技能成为独立实体，会如何影响施放、查询和销毁？可以用同一组测试比较这两种方案，再决定是否扩展框架 API。

协作约定见 [AGENTS.md](AGENTS.md)。项目使用 [MIT 许可证](LICENSE)。
