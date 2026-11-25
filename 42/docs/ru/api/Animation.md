# Animation

**Путь подключения:** `require "ProjectMotionUI/Core/Animation"`

---

## Методы и функции

### `PMUI.AnimationController:PlayEffect(name, duration, params, onComplete)`

Starts a registered custom effect on the controlled element.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `name` | `string` | Registered effect identifier. |
| `duration` | `number|nil` | Effect duration in seconds. Defaults to 0.5. |
| `params` | `table|nil` | Parameters passed to the effect callbacks. |
| `onComplete` | `function|nil` | Callback invoked when the effect finishes. |

### `PMUI.AnimationController:new(element)`

Creates an animation controller for a UI element.
@return PMUI.AnimationController

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `element` | `PMUI.BaseElement` | Element controlled by this animation controller. |

### `PMUI.AnimationController:Tween(tag, props, duration, easing, onComplete)`

Animates one or more element properties towards their target values.
Starting a tween with an existing tag replaces the previous tween using that tag.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `tag` | `string|nil` | Unique tween identifier. Defaults to "default_tween". |
| `props` | `table` | Property names mapped to their target values. |
| `duration` | `number|nil` | Animation duration in seconds. Defaults to 0.25. |
| `easing` | `function|nil` | Easing function used to interpolate values. |
| `onComplete` | `function|nil` | Callback invoked when the tween finishes. |

### `PMUI.AnimationController:Spring(props, stiffness, damping)`

Creates or updates spring animations for the specified element properties.
Existing spring velocity is preserved when a property already has an active spring.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `props` | `table` | Property names mapped to their target values. |
| `stiffness` | `number|nil` | Spring stiffness. Defaults to 180. |
| `damping` | `number|nil` | Spring damping. Defaults to 12. |

### `PMUI.AnimationController:Impulse(vx, vy, stiffness, damping)`

Applies an impulse to the element's animation offsets.
Both offsets are animated back to zero using spring physics.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `vx` | `number|nil` | Initial horizontal velocity. |
| `vy` | `number|nil` | Initial vertical velocity. |
| `stiffness` | `number|nil` | Spring stiffness. Defaults to 220. |
| `damping` | `number|nil` | Spring damping. Defaults to 10. |

### `PMUI.AnimationController:FallDown(bounciness, gravity, onComplete, initVx, initVy)`

Simulates the element falling under gravity with horizontal movement and bouncing.
The element remains within its parent or screen boundaries.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `bounciness` | `number|nil` | Bounce strength, clamped between 0.1 and 0.85. Defaults to 0.5. |
| `gravity` | `number|nil` | Downward acceleration. Defaults to 2200. |
| `onComplete` | `function|nil` | Callback invoked when the element settles. |
| `initVx` | `number|nil` | Initial horizontal velocity. |
| `initVy` | `number|nil` | Initial vertical velocity. |

### `PMUI.AnimationController:RestoreFromFall(instant)`

Stops the falling effect and restores the element to its original position.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `instant` | `boolean|nil` | If true, resets offsets immediately; otherwise uses spring animation. |

### `PMUI.AnimationController:Shatter(cols, rows, force, onComplete)`

Breaks the element into animated fragments that scatter and fade out.
A temporary effect layer is created to render the fragments independently.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `cols` | `number|nil` | Number of fragment columns. Defaults to 4. |
| `rows` | `number|nil` | Number of fragment rows. Defaults to 3. |
| `force` | `number|nil` | Fragment scattering force. Defaults to 450. |
| `onComplete` | `function|nil` | Callback invoked after all fragments disappear. |

### `PMUI.AnimationController:Shake(intensity, duration)`

Applies a horizontal shake animation that gradually decreases in intensity.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `intensity` | `number|nil` | Maximum horizontal displacement. Defaults to 6. |
| `duration` | `number|nil` | Animation duration in seconds. Defaults to 0.35. |

### `PMUI.AnimationController:Bounce(height, duration)`

Moves the element vertically in a short bouncing motion.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `height` | `number|nil` | Maximum vertical displacement. Defaults to 8. |
| `duration` | `number|nil` | Animation duration in seconds. Defaults to 0.3. |

### `PMUI.AnimationController:FadeIn(duration, onComplete)`

Fades the element in by animating its alpha from zero to one.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `duration` | `number|nil` | Fade duration in seconds. Defaults to 0.25. |
| `onComplete` | `function|nil` | Callback invoked when the fade finishes. |

### `PMUI.AnimationController:FadeOut(duration, onComplete)`

Fades the element out by animating its alpha to zero.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `duration` | `number|nil` | Fade duration in seconds. Defaults to 0.25. |
| `onComplete` | `function|nil` | Callback invoked when the fade finishes. |

### `PMUI.AnimationController:SlideIn(direction, distance, duration, onComplete)`

Slides the element into its original position from the specified direction.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `direction` | `string` | Entry direction: "left", "right", "top", or "bottom". |
| `distance` | `number|nil` | Initial displacement in pixels. Defaults to 40. |
| `duration` | `number|nil` | Animation duration in seconds. Defaults to 0.3. |
| `onComplete` | `function|nil` | Callback invoked when the animation finishes. |

### `PMUI.AnimationController:Update(dt)`

Updates all active tweens, springs, and effects.
Applies the resulting position changes after all animation calculations are complete.

| Параметр | Тип | Описание |
| :--- | :--- | :--- |
| `dt` | `number` | Time elapsed since the previous update, in seconds. |

