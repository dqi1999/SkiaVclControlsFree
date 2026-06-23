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
- **Smooth Animations** - Built-in hover and click animations
- **MUI Themes** - Built-in Material-UI color schemes
- **Chinese Support** - Auto-detect and use system Chinese fonts
- **Transparent Rendering** - Alpha channel transparency, parent-child compositing
- **Disabled State** - Complete Enabled/Disabled visual state support

---

## Controls

### Basic Controls

| Control | Description |
|---------|-------------|
| `TDSkLabel` | Skia-rendered transparent label with gradient, stroke, shadow and auto-size |
| `TDSkButton` | Material Design button with MUI colors, Ripple animation, multiple styles and icons |
| `TDSkButtonGroup` | Button group, supports horizontal/vertical layout and exclusive selection |
| `TDSkPanel` | Material Design panel with various container styles and hover effects |

### Selection Controls

| Control | Description |
|---------|-------------|
| `TDSkRadio` | Radio button, MUI style, transparent background |
| `TDSkRadioGroup` | Radio button group, self-drawing mode, with caption support |
| `TDSkCheckbox` | Checkbox with tri-state support (unchecked/checked/indeterminate) |
| `TDSkCheckboxGroup` | Checkbox group, supports multi-select |
| `TDSkSwitch` | Switch control, track + thumb sliding switch |
| `TDSkSwitchGroup` | Switch group |
| `TDSkEdit` | Edit control with label, placeholder, clear button, error state |
| `TDSkSelect` | Select dropdown with search, clear, multiple sizes |

### Feedback Controls

| Control | Description |
|---------|-------------|
| `TDSkSlider` | Slider, supports continuous/discrete/range/vertical sliders |
| `TDSkProgressBar` | Linear progress bar, supports determinate/indeterminate/buffer modes |
| `TDSkCircularProgress` | Circular progress indicator |
| `TDSkSnackbar` | Snackbar with auto-hide and action button |

### Navigation Controls

| Control | Description |
|---------|-------------|
| `TDSkTabs` | Tabs, supports standard/bottom navigation styles, horizontal/vertical |
| `TDSkStepper` | Stepper with step status management and custom content |

---

## Requirements

- **Delphi 11 Alexandria** or higher (Skia support required)
- **Windows** platform
- **Skia Package** - Select Skia during Delphi installation

---

## Installation

### Install via Delphi IDE

1. Clone or download this repository
2. Open `SkiaVclControls.dpk` (design-time package)
3. Right-click `SkiaVclControls.bpl` in Project Manager
4. Select **Compile**, then **Install**
5. Components will appear in the **SkiaVclControlsfree** tab

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

### TDSkRadioGroup Example

```delphi
uses
  SkiaVclControls.RadioGroup, SkiaVclControls.Types;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RadioGroup1 := TDSkRadioGroup.Create(Self);
  RadioGroup1.Parent := Self;
  RadioGroup1.Caption := 'Select Option';
  RadioGroup1.Items.Add('Option 1');
  RadioGroup1.Items.Add('Option 2');
  RadioGroup1.Items.Add('Option 3');
  RadioGroup1.ItemIndex := 0;
  RadioGroup1.MUIColorScheme := muiPrimary;
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
│   ├── SkiaVclControls.ButtonGroup.pas  # Button group
│   ├── SkiaVclControls.Panel.pas        # Panel
│   ├── SkiaVclControls.Radio.pas        # Radio button
│   ├── SkiaVclControls.RadioGroup.pas   # Radio button group
│   ├── SkiaVclControls.Checkbox.pas     # Checkbox
│   ├── SkiaVclControls.CheckboxGroup.pas# Checkbox group
│   ├── SkiaVclControls.Switch.pas       # Switch
│   ├── SkiaVclControls.SwitchGroup.pas  # Switch group
│   ├── SkiaVclControls.Slider.pas       # Slider
│   ├── SkiaVclControls.Edit.pas         # Edit
│   ├── SkiaVclControls.Select.pas       # Select
│   ├── SkiaVclControls.ProgressBar.pas  # Progress bar
│   ├── SkiaVclControls.CircularProgress.pas # Circular progress
│   ├── SkiaVclControls.Snackbar.pas     # Snackbar
│   ├── SkiaVclControls.Stepper.pas      # Stepper
│   ├── SkiaVclControls.Tabs.pas         # Tabs
│   ├── SkiaVclControls.MUIHelper.pas    # MUI color helper
│   └── SkiaVclControls.Register.pas     # Component registration
├── Demo/                            # Demo applications
│   └── AdminDemo/                   # Admin Demo
├── screenshots/                     # Screenshots
├── SkiaVclControls.dpk              # Design-time package
└── build.bat                        # Build script
```

---

## Screenshots

### Admin Demo
![Admin Demo](screenshots/Demo-Admin.gif)

### TDSkLabel
![Label](screenshots/tab_00_Label.png)

### TDSkButton
![Button](screenshots/tab_01_Button.png)

### TDSkPanel
![Panel](screenshots/tab_02_Panel.png)

### TDSkRadio
![Radio](screenshots/tab_03_Radio.png)

### TDSkCheckbox
![Checkbox](screenshots/tab_04_Checkbox.png)

### TDSkSwitch
![Switch](screenshots/tab_05_Switch.png)

### TDSkSlider
![Slider](screenshots/tab_06_Slider.png)

### TDSkProgressBar / TDSkCircularProgress
![Progress](screenshots/tab_07_progress.png)

### TDSkSelect
![Select](screenshots/tab_08_select.png)

### TDSkEdit
![Edit](screenshots/tab_09_edit.png)

### TDSkSnackbar
![Snackbar](screenshots/tab_10_snackbar.png)

### TDSkButtonGroup
![ButtonGroup](screenshots/tab_11_button_group.png)

### TDSkTabs
![Tabs](screenshots/tab_12_Tabs.png)

### TDSkStepper
![Stepper](screenshots/tab_13_stepper.png)

---

## License

This project is licensed under the [MIT](LICENSE) License

---

## Acknowledgements

- [Skia](https://skia.org/) - Powerful 2D graphics library
- [Material Design](https://m3.material.io/) - Google Material Design 3
