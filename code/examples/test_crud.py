from code.examples.crud import CRUD


def test_init():
    app = CRUD()
    assert app.items == []


def test_repr():
    app = CRUD()
    item = app.create_item(1, "Test Item")
    assert repr(item) == "Item(id=1, name=Test Item, description=None)"


def test_init():
    app = CRUD()
    assert app.items == []


def test_create_item():
    app = CRUD()
    item = app.create_item(1, "Test Item")
    assert len(app.list_items()) == 1
    assert item.name == "Test Item"
    assert item.id == 1
    assert item.description is None


def test_read_item():
    app = CRUD()
    item1 = app.create_item(1, 'Item 1')
    item2 = app.create_item(2, 'Item 2')

    assert app.read_item(1) == item1
    assert app.read_item(2) == item2

    assert app.read_item(3) is None


def test_update_item():
    app = CRUD()
    item1 = app.create_item(1, 'Item 1')
    item2 = app.create_item(2, 'Item 2')

    updated_item = app.update_item(1, name='Updated Item 1', description='This is an updated description')
    assert updated_item.name == 'Updated Item 1'
    assert updated_item.description == 'This is an updated description'

    original_item = app.read_item(1)
    assert original_item.name == 'Updated Item 1'
    assert original_item.description == 'This is an updated description'

    # Test that the item was not updated for another ID
    app.update_item(2, name='Another Update')
    original_item = app.read_item(1)
    assert original_item.name == 'Updated Item 1'
    assert original_item.description == 'This is an updated description'


def test_delete_item():
    app = CRUD()
    item1 = app.create_item(1, 'Item 1')
    item2 = app.create_item(2, 'Item 2')

    assert app.delete_item(1) == item1
    assert item1 not in app.list_items()
    assert item2 in app.list_items()

    deleted_item = app.delete_item(2)
    assert deleted_item == item2
    assert item2 not in app.list_items()


def test_list_items():
    app = CRUD()
    item1 = app.create_item(1, 'Item 1')
    item2 = app.create_item(2, 'Item 2')

    result = app.list_items()

    assert len(result) == 2
    assert result[0].id == 1 and result[0].name == 'Item 1'
    assert result[1].id == 2 and result[1].name == 'Item 2'

    item3 = app.create_item(3, 'Item 3')
    result = app.list_items()

    assert len(result) == 3
    assert result[0].id == 1 and result[0].name == 'Item 1'
    assert result[1].id == 2 and result[1].name == 'Item 2'
    assert result[2].id == 3 and result[2].name == 'Item 3'

    app.delete_item(2)
    result = app.list_items()

    assert len(result) == 2
    assert result[0].id == 1 and result[0].name == 'Item 1'
    assert result[1].id == 3 and result[1].name == 'Item 3'

    app.delete_item(1)
    result = app.list_items()

    assert len(result) == 0


