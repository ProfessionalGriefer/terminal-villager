# Define the sound playing logic
def play_error_sound [] {
    # Nushell stores the exit code of the last command in $env.LAST_EXIT_CODE
    let status = $env.LAST_EXIT_CODE

    # Ignore success (0) and Ctrl+C (130)
    if $status == 0 or $status == 130 {
        return
    }

    let sound_dir = ("~/.local/share/sounds" | path expand)

    # Check if the directory exists
    if not ($sound_dir | path exists) {
        print $"Sound directory not found: ($sound_dir)"
        return
    }

    # Helper closure to safely glob files and return an empty list if none are found
    let get_files = {|pattern|
        try { glob ($sound_dir | path join $pattern) } catch { [] }
    }

    let sound_files = (do $get_files "*.ogg")
    let death_files = (do $get_files "*death*.ogg")
    let hurt_files = (do $get_files "*hurt*.ogg")
    let confused_files = (do $get_files "*trade*.ogg")

    # Only proceed if there are sound files
    if ($sound_files | is-empty) {
        print $"No sound files matched glob: ($sound_dir | path join '*.ogg')"
        return
    }

    # Determine which sound to play by shuffling the list and picking the first one
    let sound_file = if $status == 1 and not ($hurt_files | is-empty) {
        $hurt_files | shuffle | first
    } else if $status == 127 and not ($confused_files | is-empty) {
        $confused_files | shuffle | first
    } else if $status == 137 and not ($death_files | is-empty) {
        $death_files | shuffle | first
    } else {
        $sound_files | shuffle | first
    }

    # Check for a sound player and run it
    # We use `sh -c` to detach the process to the background so it doesn't block your prompt.
    if not (which afplay | is-empty) {
        sh -c $"afplay '($sound_file)' >/dev/null 2>&1 &"
    } else if not (which paplay | is-empty) {
        sh -c $"paplay '($sound_file)' >/dev/null 2>&1 &"
    } else if not (which aplay | is-empty) {
        sh -c $"aplay -q '($sound_file)' >/dev/null 2>&1 &"
    }
}

# Attach the function to Nushell's pre-prompt hook
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt | append {|| play_error_sound }
)
