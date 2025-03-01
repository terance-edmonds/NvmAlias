# NvmAlias

A PowerShell utility for Windows to run `npm`, `yarn`, or `pnpm` with specific Node.js versions managed by `nvm`. Think of it as a dynamic alias system (like in Ubuntu) for package managers, letting you easily switch between Node versions without manually typing full paths.

## Features

- Run `npm`, `yarn`, or `pnpm` with a specified Node.js version (e.g., `npmv v22 start`).
- Automatically picks the latest matching version if partial (e.g., `v22` uses `v22.9.0` if available).
- Uses exact versions when specified (e.g., `v22.7.0`).
- Displays the Node.js version with `--version` or `-v`.

## Prerequisites

- **Node Version Manager (nvm) for Windows**: Install from [nvm-windows](https://github.com/coreybutler/nvm-windows).
- **PowerShell**: Comes with Windows (any modern version works).

## Installation

1. **Install nvm for Windows**
   - Download and install `nvm` from [releases](https://github.com/coreybutler/nvm-windows/releases).
   - Verify installation:
     ```powershell
     nvm version
     ```

2. **Install Node.js Versions**
   - Use `nvm` to install the Node versions you need:
     ```powershell
     nvm install 22.9.0
     nvm install 20.11.0
     ```
   - List installed versions:
     ```powershell
     nvm list
     ```

3. **(Optional) Install Yarn and pnpm**
   - For `yarnv` and `pnpmv` to work, install these globally for each Node version:
     ```powershell
     nvm use 22.9.0
     npm install -g yarn pnpm
     ```

4. **Add NvmAlias to PowerShell Profile**
   - Open your PowerShell profile:
     ```powershell
     notepad $PROFILE
     ```
   - If it doesn’t exist, PowerShell will prompt to create it. Confirm with `Y`.
   - Copy and paste the script from [`NvmAlias.ps1`](./NvmAlias.ps1) into your profile.
   - Save and reload your profile:
     ```powershell
     . $PROFILE
     ```

## Usage

### Using nvm
- **Install a version**:
  ```powershell
  nvm install 22
  ```
- **Switch versions**:
  ```powershell
  nvm use 22.9.0
  ```
- **List installed versions**:
  ```powershell
  nvm list
  ```

NvmAlias builds on this by letting you run package managers without needing `nvm use` every time.

### Using Aliases
Run commands with `npmv`, `yarnv`, or `pnpmv` followed by a version and arguments.

#### npmv
- Run `npm start` with the latest `v22` version:
  ```powershell
  npmv v22 start
  # Running with Node version: v22.9.0 using npm
  ```
- Use an exact version:
  ```powershell
  npmv v22.7.0 install express
  # Running with Node version: v22.7.0 using npm
  ```
- Check Node.js version:
  ```powershell
  npmv 22 --version
  # Running with Node version: v22.9.0
  # v22.9.0
  ```

#### yarnv
- Run `yarn install`:
  ```powershell
  yarnv v22 install
  # Running with Node version: v22.9.0 using yarn
  ```
- Check Node.js version:
  ```powershell
  yarnv v20 -v
  # Running with Node version: v20.11.0
  # v20.11.0
  ```

#### pnpmv
- Run `pnpm add lodash`:
  ```powershell
  pnpmv v22 add lodash
  # Running with Node version: v22.9.0 using pnpm
  ```
- Check Node.js version:
  ```powershell
  pnpmv 22.7.0 --version
  # Running with Node version: v22.7.0
  # v22.7.0
  ```

- **Note**: Omit the `v` prefix if you prefer (e.g., `npmv 22` works like `npmv v22`).

## How It Works

- **Version Resolution**: 
  - `v22` finds the latest installed version (e.g., `v22.9.0` if you have `v22.0.2`, `v22.7.0`, `v22.9.0`).
  - Exact matches (e.g., `v22.7.0`) take priority.
- **Package Manager**: Detects `npmv`, `yarnv`, or `pnpmv` and uses the corresponding tool from the Node version folder.
- **Path**: Uses `C:\Users\<YourUser>\AppData\Roaming\nvm\<version>\<tool>.cmd`.

## Troubleshooting

- **"No matching Node version found"**: Ensure the version is installed with `nvm list`.
- **"yarn/pnpm not found"**: Install them globally for that Node version (e.g., `npmv v22 install -g yarn`).
- **Profile not loading**: Verify `$PROFILE` path and reload with `. $PROFILE`.

## License

MIT License - see [LICENSE](./LICENSE) for details.