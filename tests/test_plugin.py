BUFOPTS = {
    "bt": "nofile",
    "ft": "fstree",
    "bufhidden": "wipe",
    "swapfile": False,
    "modifiable": False,
}


def test_buf_opts(fsbuf):
    for k, v in BUFOPTS.items():
        assert fsbuf.options.get(k) == v


def test_open_new(fsbuf):
    assert fsbuf[:] == [
        "+ d-1",
        "+ d-2",
        "+ d-3",
        "+ z-4",
        "  a-1",
        "  b-1",
        "  z-1",
    ]

# test expand top dir
# test expand middle dir
# test expand bottom dir
# test expand file
# test expand top subdir
# test expand middle subdir
# test expand bottom subdir
