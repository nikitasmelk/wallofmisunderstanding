(
s.waitForBoot {
    // Resolve a robust path in case you ever change working dirs:
    var absPath = File.resolveRelativePath("myscript.py");
    var call    = "python3 " ++ absPath;

    // run it non‐blocking; true→print stdout+stderr
    call.unixCmd({ |exitCode, pid|
        if (exitCode == 0) {
            (" Python script (pid " ++ pid ++ ") finished OK.").postln;
        } {
            (" Python script failed with exit " ++ exitCode).postln;
        }
    }, true);
};
)
