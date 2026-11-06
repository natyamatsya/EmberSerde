from std.testing import assert_equal, TestSuite
from _debug_format import debug_string
from emberserde.field import Rename, Skip, SkipIfNone


@fieldwise_init
struct Rec(Copyable, Movable):
    var a: Int

    @__annotation(Rename("b"))
    var renamed: Int

    @__annotation(Skip())
    var hidden: Int


def test_field_rename_and_skip() raises:
    var r = Rec(
        a=1,
        renamed=2,
        hidden=3,
    )
    # `renamed` emits under "b"; `hidden` drops out and the field count is 2.
    assert_equal(debug_string(r), "test_field.Rec { a: 1, b: 2 }")


@fieldwise_init
struct Sparse(Copyable, Movable):
    var a: Int

    @__annotation(SkipIfNone())
    var b: Optional[Int]

    var c: Optional[Int]


def test_skip_if_none() raises:
    assert_equal(
        debug_string(Sparse(a=1, b=2, c=3)),
        "test_field.Sparse { a: 1, b: Some(2), c: Some(3) }",
    )
    # only the annotated field drops out while `None`
    assert_equal(
        debug_string(Sparse(a=1, b=None, c=None)),
        "test_field.Sparse { a: 1, c: None }",
    )


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
