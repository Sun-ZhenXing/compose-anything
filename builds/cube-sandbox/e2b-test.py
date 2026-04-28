#!/usr/bin/env python3
"""
Basic E2B SDK integration test against a local CubeSandbox instance.

Runs three checks:
  1. Sandbox creation (debug=True → API at http://localhost:3000)
  2. Code execution and output validation
  3. Sandbox teardown

Usage (inside the cube-sandbox container):
    python3 /root/e2b-test.py

Exit codes:
    0  all tests passed
    1  any test failed
"""
import sys

PASS = "\033[1;32m[ OK ]\033[0m"
FAIL = "\033[1;31m[FAIL]\033[0m"
INFO = "\033[1;36m[INFO]\033[0m"


def check(label: str, cond: bool, detail: str = "") -> bool:
    if cond:
        print(f"{PASS} {label}")
    else:
        print(f"{FAIL} {label}{': ' + detail if detail else ''}")
    return cond


def main() -> int:
    ok = True

    # ------------------------------------------------------------------ #
    # 1. Import                                                            #
    # ------------------------------------------------------------------ #
    print(f"{INFO} Importing e2b_code_interpreter …")
    try:
        from e2b_code_interpreter import Sandbox  # type: ignore
    except ImportError as exc:
        print(f"{FAIL} import failed: {exc}")
        return 1
    ok &= check("e2b_code_interpreter imported", True)

    # ------------------------------------------------------------------ #
    # 2. Create sandbox                                                    #
    # ------------------------------------------------------------------ #
    print(f"\n{INFO} Creating sandbox (debug=True → http://localhost:3000) …")
    sb = None
    try:
        # debug=True makes the SDK target http://localhost:3000 instead of
        # the E2B cloud and http://localhost:<port> for the envd connection.
        sb = Sandbox(debug=True, api_key="local-test", timeout=120)
        ok &= check("Sandbox created", sb is not None, f"id={sb.sandbox_id if sb else '?'}")
        print(f"       sandbox_id = {sb.sandbox_id}")
    except Exception as exc:
        ok &= check("Sandbox created", False, str(exc))
        print(f"\n{INFO} Skipping remaining tests (sandbox creation failed)")
        return 0 if ok else 1

    # ------------------------------------------------------------------ #
    # 3. Execute code                                                      #
    # ------------------------------------------------------------------ #
    print(f"\n{INFO} Running code inside sandbox …")
    try:
        result = sb.run_code('print("Hello from CubeSandbox!")')
        expected = "Hello from CubeSandbox!"
        output = (result.text or "").strip()
        ok &= check("Code executed without error", not result.error,
                    str(result.error) if result.error else "")
        ok &= check("Output matches expected", output == expected,
                    f"got {output!r}")
    except Exception as exc:
        ok &= check("Code execution", False, str(exc))

    # ------------------------------------------------------------------ #
    # 4. Multi-line / stateful execution                                   #
    # ------------------------------------------------------------------ #
    print(f"\n{INFO} Running stateful multi-cell execution …")
    try:
        sb.run_code("x = 40 + 2")
        result2 = sb.run_code("print(x)")
        output2 = (result2.text or "").strip()
        ok &= check("Stateful multi-cell execution", output2 == "42",
                    f"got {output2!r}")
    except Exception as exc:
        ok &= check("Stateful multi-cell execution", False, str(exc))

    # ------------------------------------------------------------------ #
    # 5. Kill sandbox                                                      #
    # ------------------------------------------------------------------ #
    print(f"\n{INFO} Killing sandbox …")
    try:
        sb.kill()
        ok &= check("Sandbox killed", True)
    except Exception as exc:
        ok &= check("Sandbox killed", False, str(exc))

    # ------------------------------------------------------------------ #
    # Summary                                                              #
    # ------------------------------------------------------------------ #
    print()
    if ok:
        print(f"{PASS} All E2B SDK tests passed")
    else:
        print(f"{FAIL} Some E2B SDK tests FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
