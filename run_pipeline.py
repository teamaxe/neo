import os
import subprocess
import sys

def run_shell_script(script_name="nasa_pipepeline_runner.sh"):
    # Resolve absolute path to the script
    script_path = os.path.join(os.path.dirname(__file__), script_name)

    if not os.path.exists(script_path):
        print(f"Error: Script '{script_name}' not found at {script_path}")
        sys.exit(1)

    # Ensure executable permissions on Linux/macOS
    os.chmod(script_path, 0o755)

    print(f"Executing {script_name}...")
    try:
        # Run the shell script and stream output directly to terminal
        result = subprocess.run(
            ["bash", script_path],
            check=True,
            text=True
        )
        print(f"Finished executing {script_name} (Exit Code: {result.returncode})")
    except subprocess.CalledProcessError as e:
        print(f"Error executing {script_name}: Exit Code {e.returncode}")
        sys.exit(e.returncode)

if __name__ == "__main__":
    run_shell_script()
