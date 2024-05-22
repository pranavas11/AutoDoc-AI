from examples.crud import YourClass
from examples.crud import CRUD


def test_init():
    # Preparation: Create an instance of the CRUD class
    crud = CRUD()

    # Execution: Call the __init__ method on the created instance
    crud.__init__()

    # Checking: Check if the internal state is as expected
    assert crud.items == []

    # Cleaning: No cleaning needed for this test, as it only checks the initial state


def test_repr():
    # Preparation: Create an instance of the Item class and an instance of the CRUD class.
    item = Item(1, "Test Item")
    crud = CRUD()

    # Execution: Call the __repr__ method on the item object.
    result = item.__repr__()

    # Checking: Check if the returned string matches the expected format.
    assert result == "Item(id=1, name=Test Item, description=None)"

    # Cleaning: No cleaning is required for this test.

def test_repr_with_description():
    # Preparation: Create an instance of the Item class and an instance of the CRUD class.
    item = Item(2, "Another Test Item", "This is a test description")
    crud = CRUD()

    # Execution: Call the __repr__ method on the item object.
    result = item.__repr__()

    # Checking: Check if the returned string matches the expected format with description.
    assert result == "Item(id=2, name=Another Test Item, description=This is a test description)"

    # Cleaning: No cleaning is required for this test.

def test_repr_with_no_description():
    # Preparation: Create an instance of the Item class and an instance of the CRUD class.
    item = Item(3, "No Description Test Item")
    crud = CRUD()

    # Execution: Call the __repr__ method on the item object.
    result = item.__repr__()

    # Checking: Check if the returned string matches the expected format with no description.
    assert result == "Item(id=3, name=No Description Test Item, description=None)"

    # Cleaning: No cleaning is required for this test.


def test_init():
    # Preparation: Create an instance of the CRUD class
    crud = CRUD()

    # Execution: Call the __init__ method on the created instance
    crud.__init__()

    # Checking: Check if the internal state is as expected
    assert crud.items == []

    # Cleaning: No cleaning needed for this test, as it only checks the initial state


def test_create_item():
    # Preparation: Create an instance of the CRUD class
    crud = CRUD()

    # Execution: Call the create_item method with valid input
    item1 = crud.create_item(1, "Item 1", description="This is Item 1")
    item2 = crud.create_item(2, "Item 2", description="This is Item 2")

    # Checking: Check if the items were created correctly
    assert len(crud.items) == 2
    assert item1.id == 1 and item1.name == "Item 1" and item1.description == "This is Item 1"
    assert item2.id == 2 and item2.name == "Item 2" and item2.description == "This is Item 2"

    # Cleaning: No cleaning needed for this test


def test_read_item_found():
    # Preparation: Create an item in the collection before running the test
    crud = CRUD()
    item = crud.create_item(1, "Test Item", "This is a test item")
    
    # Execution: Call the read_item method with the ID of the created item
    result = crud.read_item(1)
    
    # Checking: Check if the returned item matches the expected one
    assert result.id == 1 and result.name == "Test Item" and result.description == "This is a test item"
    
    # Cleaning: No need to clean up in this case, as we only created an item

def test_read_item_not_found():
    # Preparation: Create no items in the collection before running the test
    crud = CRUD()
    
    # Execution: Call the read_item method with an ID that does not exist in the collection
    result = crud.read_item(1)
    
    # Checking: Check if the returned item is None, indicating that the item was not found
    assert result is None
    
    # Cleaning: No need to clean up in this case, as we did not create any items

def test_read_item_multiple_items():
    # Preparation: Create multiple items in the collection before running the test
    crud = CRUD()
    for i in range(5):
        crud.create_item(i, f"Test Item {i}", f"This is a test item {i}")
    
    # Execution: Call the read_item method with an ID that exists in the collection
    result = crud.read_item(2)
    
    # Checking: Check if the returned item matches the expected one
    assert result.id == 2 and result.name == "Test Item 2" and result.description == "This is a test item 2"
    
    # Cleaning: No need to clean up in this case, as we only created items


def test_update_item():
    # Preparation: Create an item in the collection before running the test
    crud = CRUD()
    item1 = crud.create_item(1, 'Item 1', 'This is Item 1')
    
    # Execution: Update the item with ID 1
    updated_item = crud.update_item(1, name='Updated Item 1', description='This is an updated description')

    # Checking: Check if the item has been updated correctly
    assert updated_item.name == 'Updated Item 1'
    assert updated_item.description == 'This is an updated description'

    # Cleaning: No need to clean up in this test, as we only created one item and didn't modify any external state

def test_update_item_non_existent_id():
    # Preparation: Create an item in the collection before running the test
    crud = CRUD()
    item1 = crud.create_item(1, 'Item 1', 'This is Item 1')
    
    # Execution: Try to update a non-existent item with ID 2
    updated_item = crud.update_item(2, name='Updated Item 2', description='This is an updated description')

    # Checking: Check if the method returns None as expected
    assert updated_item is None

    # Cleaning: No need to clean up in this test, as we only created one item and didn't modify any external state

def test_update_item_no_changes():
    # Preparation: Create an item in the collection before running the test
    crud = CRUD()
    item1 = crud.create_item(1, 'Item 1', 'This is Item 1')
    
    # Execution: Try to update the item with ID 1 without making any changes
    updated_item = crud.update_item(1, name='Item 1', description='This is Item 1')

    # Checking: Check if the method returns the same item as expected
    assert updated_item.name == 'Item 1'
    assert updated_item.description == 'This is Item 1'

    # Cleaning: No need to clean up in this test, as we only created one item and didn't modify any external state


def test_delete_item():
    # Preparation: Create an item to be deleted
    cr = CRUD()
    item_to_delete = cr.create_item("1", "Test Item 1")

    # Execution: Delete the item
    deleted_item = cr.delete_item(item_to_delete.id)

    # Checking: Check if the item was deleted correctly
    assert deleted_item is None

    # Cleaning: No cleaning needed, as we only created and deleted one item


def test_list_items():
    # Preparation: Create an instance of the CRUD class and add some items to it.
    crud = CRUD()
    item1 = crud.create_item(1, "Item 1")
    item2 = crud.create_item(2, "Item 2", description="This is Item 2")
    
    # Execution: Call the list_items method on the created instance.
    result = crud.list_items()
    
    # Checking: Check if the returned list contains the expected items.
    assert len(result) == 2
    assert item1 in result
    assert item2 in result
    
    # Cleaning: No cleaning is needed for this test, as we only create and retrieve items without modifying them.


