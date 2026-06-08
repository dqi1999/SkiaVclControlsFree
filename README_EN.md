# SkiaVclControlsfree

Material Design VCL Controls based on Delphi built-in Skia (Lite Edition)

[![Delphi](https://img.shields.io/badge/Delphi-11+-red.svg)](https://www.embarcadero.com/products/delphi)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[中文](README.md) | **English**

---

## Features

- **Material Design 3** style
- **Skia Rendering** - High-quality graphics with Delphi built-in Skia support
- **DPI-Aware** - Perfect support for high-DPI displays
- **Smooth Animations** - Built-in hover and click animations (Ripple/Glow/ScaleUp)
- **MUI Themes** - Built-in Material-UI color schemes
- **Chinese Support** - Auto-detect and use system Chinese fonts
- **Transparent Rendering** - Alpha channel transparency, parent-child compositing
- **Disabled State** - Complete Enabled/Disabled visual state support
- **Design-time Preview** - Full design-time visual editing support

---

## Controls

| Control | Description |
|---------|-------------|
| `TDSkLabel` | Material Design label with gradient, outline, and shadow effects |
| `TDSkButton` | Material Design button with MUI colors, Ripple animation, multiple styles and icons |
| `TDSkPanel` | Material Design panel with various container styles and hover effects |
| `TDSkRadio` | Radio button, MUI style, transparent background support |
| `TDSkRadioGroup` | Radio button group, self-drawing mode, with caption support |
| `TDSkCheckbox` | Checkbox with tri-state support (unchecked/checked/indeterminate) |
| `TDSkSwitch` | Switch control, track + thumb sliding switch |
| `TDSkSlider` | Slider, supports continuous/discrete/range/vertical sliders |
| `TDSkTabs` | Tabs, supports standard/bottom navigation styles, horizontal/vertical |

---

## Requirements

- **Delphi 11 Alexandria** or higher (Skia support required)
- **Windows** platform
- **Skia Package** - Select Skia during Delphi installation

---

## Installation

### Method 1: Install via Delphi IDE

1. Clone or download this repository
2. Open `SkiaVclControls.dpk` (design-time package)
3. Right-click `SkiaVclControls.bpl` in Project Manager
4. Select **Compile**, then **Install**
5. Components will appear in the **SkiaVclControlsfree** tab

### Method 2: Use Build Script

```batch
build.bat
```

Then manually install the generated `SkiaVclControls.bpl`

---

## Quick Start

### TDSkButton Example

```delphi
uses
  SkiaVclControls.Button, SkiaVclControls.Types;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button1 := TDSkButton.Create(Self);
  Button1.Parent := Self;
  Button1.ButtonText := 'Click Me';
  Button1.MUIColorScheme := muiPrimary;
  Button1.MUIStyle := muiContained;
  Button1.HoverEffect := heRipple;
end;
```

### TDSkPanel Example

```delphi
uses
  SkiaVclControls.Panel, SkiaVclControls.Types;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1 := TDSkPanel.Create(Self);
  Panel1.Parent := Self;
  Panel1.Caption := 'Title';
  Panel1.PanelStyle := psOutlined;
  Panel1.CornerRadius := 12;
  Panel1.HoverEnabled := True;
end;
```

### TDSkRadioGroup Example

```delphi
uses
  SkiaVclControls.RadioGroup, SkiaVclControls.Types;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RadioGroup1 := TDSkRadioGroup.Create(Self);
  RadioGroup1.Parent := Self;
  RadioGroup1.Caption := 'Select an option';
  RadioGroup1.Items.Add('Option 1');
  RadioGroup1.Items.Add('Option 2');
  RadioGroup1.Items.Add('Option 3');
  RadioGroup1.ItemIndex := 0;
  RadioGroup1.Orientation := rgoVertical;
  RadioGroup1.ColorScheme := muiPrimary;
end;
```

---

## Project Structure

```
SkiaVclControlsfree/
├── Sources/                         # Source code
│   ├── SkiaVclControls.Types.pas        # Shared types, enumerations
│   ├── SkiaVclControls.Base.pas         # Base class
│   ├── SkiaVclControls.LabelControl.pas # Label
│   ├── SkiaVclControls.Button.pas       # Button
│   ├── SkiaVclControls.Panel.pas        # Panel
│   ├── SkiaVclControls.Radio.pas        # Radio button
│   ├── SkiaVclControls.RadioGroup.pas   # Radio button group
│   ├── SkiaVclControls.Checkbox.pas     # Checkbox
│   ├── SkiaVclControls.Switch.pas       # Switch
│   ├── SkiaVclControls.Slider.pas       # Slider
│   ├── SkiaVclControls.Tabs.pas         # Tabs
│   ├── SkiaVclControls.MUIHelper.pas    # MUI color helper
│   └── SkiaVclControls.Register.pas     # Component registration
├── Demo/                            # Demo applications (Frame architecture)
│   ├── Shared/                      # Shared units
│   │   └── Demo.Styles.pas          # Shared style constants
│   ├── Frames/                      # Reusable demo Frames
│   │   ├── Demo.Frame.LabelControl  # Label demo Frame
│   │   ├── Demo.Frame.Button        # Button demo Frame
│   │   ├── Demo.Frame.Panel         # Panel demo Frame
│   │   ├── Demo.Frame.Radio         # Radio demo Frame
│   │   ├── Demo.Frame.Checkbox      # Checkbox demo Frame
│   │   ├── Demo.Frame.Switch        # Switch demo Frame
│   │   ├── Demo.Frame.Slider        # Slider demo Frame
│   │   └── Demo.Frame.Tabs          # Tabs demo Frame
│   ├── Button/                      # Button demo
│   ├── Panel/                       # Panel demo
│   ├── Radio/                       # Radio button demo
│   ├── Slider/                      # Slider demo
│   ├── Checkbox/                    # Checkbox demo
│   ├── Switch/                      # Switch demo
│   ├── Tabs/                        # Tabs demo
│   └── AdminDemo/                   # Comprehensive demo (Admin style)
├── SkiaVclControls.dpk              # Design-time package
└── build.bat                        # Build script
```

---

## Demo Architecture

### Frame Architecture Design

Demo uses **Frame architecture** for code reuse and unified maintenance:

1. **Shared Layer** (`Demo/Shared/`)
   - `Demo.Styles.pas`: Material Design 3 color constants and style definitions

2. **Frame Layer** (`Demo/Frames/`)
   - `Demo.Frame.*`: Component demo Frames, can be used independently or embedded in other containers

3. **Single Component Demo** (`Demo/Button/`, `Demo/Panel/`, etc.)
   - Individual component demo programs

4. **Comprehensive Demo** (`Demo/AdminDemo/`)
   - Admin-style multi-page UI
   - Left side TDSkTabs vertical navigation
   - Right side dynamic Frame switching
   - Reuses all component Frames

### Run Demo

```bash
# Compile and run single component demo
cd Demo/Button
dcc32 ButtonDemo.dpr

# Compile and run comprehensive demo
cd Demo/AdminDemo
dcc32 AdminDemo.dpr
```

---

## Screenshots

### Admin Demo
![Admin Demo](screenshots/Demo-Admin.gif)

### TDSkLabel Demo
![Label Demo](screenshots/Demo-Label.png)

### TDSkButton Demo
![Button Demo](screenshots/Demo-Button.png)

### TDSkPanel Demo
![Panel Demo](screenshots/Demo-Panel.png)

### TDSkRadio Demo
![Radio Demo](screenshots/Demo-Radio.png)

### TDSkCheckbox Demo
![Checkbox Demo](screenshots/Demo-Checkbox.png)

### TDSkSwitch Demo
![Switch Demo](screenshots/Demo-Switch.png)

### TDSkSlider Demo
![Slider Demo](screenshots/Demo-Slider.png)

### TDSkTabs Demo
![Tabs Demo](screenshots/Demo-Tabs.png)

---

## Contributing

Issues and Pull Requests are welcome!

---

## License

This project is licensed under the [MIT](LICENSE) License

---

## Acknowledgements

- [Skia](https://skia.org/) - Powerful 2D graphics library
- [Material Design](https://m3.material.io/) - Google Material Design 3
- [Material-UI](https://mui.com/) - React UI component library (color reference)
