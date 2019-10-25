import pytest


@pytest.mark.parametrize("opt,val", [
    ("bt", "nofile"),
    ("ft", "fstree"),
    ("bufhidden", "wipe"),
    ("swapfile", False),
    ("modifiable", False),
])
def test_buf_opt(fsbuf, opt, val):
    assert fsbuf.options.get(opt) == val


def test_open_new(nvim, fsbuf):
    assert fsbuf[:] == [
        "+ d-1",
        "+ d-2",
        "+ d-3",
        "+ z-4",
        "  a-1",
        "  b-1",
        "  z-1",
    ]


def test_open_new2(nvim, fsbuf):
    assert fsbuf[:] == [
        "+ d-1",
        "+ d-2",
        "+ d-3",
        "+ z-4",
        "  a-1",
        "  b-1",
        "  z-1",
    ]


@pytest.mark.parametrize("command,line,expected", [
    ("FsTreeExpand", 1, [
        "- d-1",
        "    + d-1-1",
        "    + d-1-2",
        "    + d-1-3",
        "    + d-1-4",
        "      a-1",
        "      b-2",
        "      c-3",
        "+ d-2",
        "+ d-3",
        "+ z-4",
        "  a-1",
        "  b-1",
        "  z-1",
    ]),
])
def test_expand_collapse(nvim, fsbuf, command, line, expected):
    nvim.command(f"call cursor({line},1)")
    nvim.command(command)
    assert fsbuf[:] == expected


# test expand top dir
# test expand middle dir
# test expand bottom dir
# test expand file
# test expand top subdir
# test expand middle subdir
# test expand bottom subdir
