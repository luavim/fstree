BUFOPTS = {
    "bt": "nofile",
    "ft": "fstree",
    "bufhidden": "wipe",
    "swapfile": False,
    "modifiable": False,
}


def test_open_new(nvim):
    nvim.command("FsTreeOpen")
    buf = nvim.buffers[2]

    # import pdb; pdb.set_trace()

    for k, v in BUFOPTS.items():
        assert buf.options.get(k) == v

    assert nvim.buffers[2][:] == ["welcome!"]
