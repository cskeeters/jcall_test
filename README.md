jcall_test
==========

Test java project for [jcall.vim](https://github.com/cskeeters/jcall.vim)

Once jcall.vim has been setup, run the following command to test.

    ./test.sh -r

Flags
-----

`test.sh` can be run with a `-c` flag to delete the temporary files
`test.sh` can be run with a `-r` flag to recompile the java first and rebuild the jcall.vim cache
`test.sh` can be run with `-r -r` flag to recompile the java first, rebuild the jcall.vim cache, and set the expected output to the current output (if you know the plugin is working correctly and don't want to hand edit the expected `.out` files)


Issue
------

If you find a bug, you can correct the expected output in `test_call` or `test_jump` and create an issue and a pull request.

