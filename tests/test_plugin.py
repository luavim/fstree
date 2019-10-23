BUFOPTS = {
    "bt": "nofile",
    "ft": "fstree",
    "bufhidden": "wipe",
    "swapfile": False,
    "modifiable": False,
}


def test_open_new(nvim, testdir):
    nvim.command("FsTreeOpen")
    buf = nvim.buffers[2]

    for k, v in BUFOPTS.items():
        assert buf.options.get(k) == v

    assert buf[:] == [
        "+ d-1",
        "+ d-2",
        "+ d-3",
        "+ d-4",
    ]
