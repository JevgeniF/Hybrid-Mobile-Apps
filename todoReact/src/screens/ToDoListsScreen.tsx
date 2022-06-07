/* eslint-disable no-shadow,react-native/no-inline-styles */
// @ts-ignore
import React, {useEffect, useState} from 'react';
import {
  FlatList,
  Modal,
  StyleSheet,
  Text,
  TouchableHighlight,
  TouchableOpacity,
  View,
} from 'react-native';
import {useTheme} from '@react-navigation/native';
import {getTasks} from '../crud/TasksCrud';
import IconFa from 'react-native-vector-icons/FontAwesome';
import IconFe from 'react-native-vector-icons/Feather';
import {
  deleteCategory,
  getCategories,
  postCategory,
  putName,
} from '../crud/CategoriesCrud';
import Swipeable from 'react-native-swipeable';
import {TextInput} from 'react-native-gesture-handler';
import LinearGradient from 'react-native-linear-gradient';
import Toast from 'react-native-simple-toast';
import {Category} from '../models/Category';

const TasksScreen = ({navigation}) => {
  const {colors} = useTheme();
  const [needUpdate, startUpdate] = useState(false);
  const [infoUpdateVisible, setInfoUpdateVisible] = useState(false);
  const [addCategoryVisible, setAddCategoryVisible] = useState(false);
  const [tasks, setTasks] = useState([]);
  const [categories, setCategories] = useState([]);
  const [categoryName, setCategoryName] = useState('');
  const [tempCategory, setTempCategory] = useState<Category>(new Category());

  useState(() => {
    getCategories().then(categories => {
      setCategories(categories);
    });
    getTasks().then(tasks => {
      setTasks(tasks);
    });
  });

  useEffect(() => {
    if (needUpdate) {
      getCategories().then(categories => {
        setCategories(categories);
        startUpdate(false);
      });
    }
  });

  useEffect(() => {
    const unsubscribe = navigation.addListener(
      'focus',
      () => {
        getTasks().then(tasks => {
          setTasks(tasks);
        });
        return unsubscribe;
      },
      [navigation],
    );
  });

  const getTasksCount = (category: Category) => {
    if (category === null) {
      return tasks.length;
    } else {
      return tasks.filter(task => task.todoCategoryId === category.id).length;
    }
  };

  const handleCategoryRemoval = (category: Category) => {
    deleteCategory(category).then(_ => startUpdate(true));
  };

  const handleCategoryUpdate = (category: Category, name: string) => {
    let newName: string;
    if (name.length < 1) {
      newName = category.categoryName;
    } else {
      newName = name;
    }

    if (category.categoryName === newName) {
      setInfoUpdateVisible(false);
      Toast.show('Nothing changed');
    } else {
      setInfoUpdateVisible(false);
      putName(category, newName).then(_ => startUpdate(true));
      setCategoryName('');
    }
  };

  const handleCategoryUpdateCancellation = () => {
    setInfoUpdateVisible(false);
    setCategoryName('');
  };

  const handleAddCategory = () => {
    let category = new Category();
    category.categoryName = categoryName;

    setAddCategoryVisible(false);
    postCategory(category).then(_ => setCategoryName(''));
    startUpdate(true);
  };

  const handleAddCategoryCancellation = () => {
    setAddCategoryVisible(false);
    setCategoryName('');
    startUpdate(true);
  };

  const passToDescriptionUpdateModal = (category: Category) => {
    setTempCategory(category);
    setInfoUpdateVisible(true);
  };

  const descriptionUpdateModal = (
    <Modal animationType="slide" transparent={true} visible={infoUpdateVisible}>
      <View style={{...styles.centeredView}}>
        <View style={{...styles.modalView, backgroundColor: colors.background}}>
          <Text style={{...styles.modalText, color: colors.text}}>
            Rename ToDo List...
          </Text>
          <View style={{...styles.action}}>
            <TextInput
              style={{...styles.textInput, color: colors.text}}
              onChangeText={value => setCategoryName(value)}
              placeholder="Enter list's name"
            />
          </View>
          <View
            style={{
              ...styles.modalButton,
            }}>
            <TouchableOpacity
              style={{...styles.update}}
              onPress={() => {
                handleCategoryUpdate(tempCategory, categoryName);
              }}>
              <LinearGradient
                colors={['#a749ff', '#1f00c4']}
                style={{...styles.update}}>
                <Text style={{...styles.textUpdate}}>Rename</Text>
              </LinearGradient>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                handleCategoryUpdateCancellation();
              }}
              style={{
                ...styles.update,
                borderColor: '#6c00f8',
                borderWidth: 1,
              }}>
              <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                Cancel
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );

  const addCategoryModal = (
    <Modal
      animationType="slide"
      transparent={true}
      visible={addCategoryVisible}>
      <View style={{...styles.centeredView}}>
        <View style={{...styles.modalView, backgroundColor: colors.background}}>
          <Text style={{...styles.modalText, color: colors.text}}>
            Add New ToDo List...
          </Text>
          <View style={{...styles.action, borderBottomWidth: 0}}>
            <View style={{...styles.action}}>
              <TextInput
                style={{...styles.textInput, color: colors.text}}
                onChangeText={value => setCategoryName(value)}
                placeholder="Enter new list's name"
              />
            </View>
          </View>
          <View
            style={{
              ...styles.modalButton,
            }}>
            <TouchableOpacity
              style={{...styles.update}}
              onPress={() => {
                if (categoryName.length < 1) {
                  Toast.show("Please enter list's name!");
                } else {
                  handleAddCategory();
                }
              }}>
              <LinearGradient
                colors={['#a749ff', '#1f00c4']}
                style={{...styles.update}}>
                <Text style={{...styles.textUpdate}}>Confirm</Text>
              </LinearGradient>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                handleAddCategoryCancellation();
              }}
              style={{
                ...styles.update,
                borderColor: '#6c00f8',
                borderWidth: 1,
              }}>
              <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                Cancel
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );

  const footerButtons = (
    <View
      style={{
        ...styles.footerButtons,
      }}>
      <TouchableOpacity
        style={{...styles.update}}
        onPress={() => {
          setAddCategoryVisible(true);
        }}>
        <View
          style={{
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
          }}>
          <IconFa name="plus-circle" color={'white'} size={25} />
          <Text style={{...styles.textUpdate, fontSize: 12}}>Add</Text>
        </View>
      </TouchableOpacity>
    </View>
  );

  const renderItemView = (item: Category) => {
    const rightButtons = [
      <TouchableHighlight
        style={[styles.rightSwipeItem, {backgroundColor: 'red'}]}
        onPress={() => {
          handleCategoryRemoval(item);
        }}>
        <IconFa name="times-circle-o" color="white" size={35} />
      </TouchableHighlight>,
    ];
    const taskDescription = (
      <TouchableOpacity
        onPress={() => {
          passToDescriptionUpdateModal(item);
        }}>
        <View style={{...styles.description}}>
          <IconFa name="list-ul" color={colors.text} size={20} />
          <Text
            style={{
              ...styles.item,
              color: colors.text,
              marginHorizontal: 10,
            }}>
            {item.categoryName}
          </Text>
        </View>
      </TouchableOpacity>
    );

    const tasksCount = (
      <TouchableOpacity
        style={{flex: 1}}
        onPress={() => {
          navigation.navigate('Tasks', {id: item.id, name: item.categoryName});
        }}>
        <View
          style={{
            ...styles.dueDateContainer,
          }}>
          <IconFe name="check-circle" color={colors.text} size={20} />
          <View
            style={{
              ...styles.dueDate,
            }}>
            <Text style={{color: colors.text, fontWeight: 'bold'}}>
              {getTasksCount(item)}
            </Text>
          </View>
        </View>
      </TouchableOpacity>
    );

    return (
      <Swipeable rightButtons={rightButtons}>
        <View style={{...styles.itemRoot}}>
          <View style={{...styles.itemContent}}>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              <View
                style={{flex: 3, flexDirection: 'row', alignItems: 'center'}}>
                {taskDescription}
              </View>
              {tasksCount}
            </View>
          </View>
        </View>
      </Swipeable>
    );
  };

  return (
    <View style={{...styles.root}}>
      <View style={{...styles.title}}>
        <Text style={{...styles.titleText, color: colors.text}}>
          ToDo Lists
        </Text>
      </View>
      <View style={{...styles.listview}}>
        <TouchableOpacity
          onPress={() => {
            navigation.navigate('Tasks', {id: 0, name: 'All Tasks'});
          }}>
          <View style={{...styles.itemRoot}}>
            <View style={{...styles.itemContent}}>
              <View style={{...styles.description}}>
                <IconFa name="list-ul" color={colors.text} size={20} />
                <Text
                  style={{
                    ...styles.item,
                    color: colors.text,
                    marginHorizontal: 10,
                  }}>
                  All Tasks
                </Text>
              </View>
              <View
                style={{
                  ...styles.dueDateContainer,
                  flex: 1,
                  marginLeft: 20,
                }}>
                <IconFe name="check-circle" color={colors.text} size={20} />
                <View
                  style={{
                    ...styles.dueDate,
                  }}>
                  <Text style={{color: colors.text, fontWeight: 'bold'}}>
                    {getTasksCount(null)}
                  </Text>
                </View>
              </View>
            </View>
          </View>
        </TouchableOpacity>
        <FlatList
          data={categories.sort((a, b) =>
            a.categoryName.localeCompare(b.categoryName),
          )}
          renderItem={({item}) => renderItemView(item)}
          keyExtractor={item => item.id}
        />
      </View>
      {addCategoryModal}
      {descriptionUpdateModal}
      {footerButtons}
    </View>
  );
};

const styles = StyleSheet.create({
  footerButtons: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 0,
    backgroundColor: '#7700ff',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingHorizontal: 20,
    paddingVertical: 5,
  },
  itemRoot: {
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
    padding: 5,
  },
  itemContent: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  item: {
    fontWeight: 'bold',
    fontSize: 18,
  },
  itemCompleted: {
    fontWeight: 'bold',
    fontSize: 18,
    textDecorationLine: 'line-through',
  },
  dueDateContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  dueDate: {
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: 10,
  },
  root: {
    height: '100%',
    width: '100%',
  },
  title: {
    flex: 1,
    //height: '12%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  titleText: {
    fontSize: 23,
    fontWeight: 'bold',
  },
  listview: {
    flex: 8,
    //height: '90%',
    paddingHorizontal: 20,
    width: '100%',
  },

  description: {
    flexDirection: 'row',
    minWidth: '68%',
    marginLeft: 10,
    alignItems: 'center',
  },

  rightSwipeItem: {
    flex: 1,
    justifyContent: 'center',
    paddingLeft: 22,
  },

  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 22,
  },
  modalView: {
    margin: 20,
    borderRadius: 20,
    padding: 35,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },

  modalText: {
    fontWeight: 'bold',
    fontSize: 18,
  },

  picker: {
    paddingHorizontal: 15,
    height: 40,
    width: 160,
    borderRadius: 15,
  },

  textInput: {
    paddingLeft: 10,
    color: '#05375a',
  },

  action: {
    alignItems: 'center',
    flexDirection: 'column',
    marginTop: 5,
    borderBottomWidth: 1,
    borderBottomColor: '#f2f2f2',
    paddingBottom: 5,
  },

  text: {
    color: '#05375a',
    fontSize: 15,
  },
  modalButton: {
    flexDirection: 'row',
    justifyContent: 'space-evenly',
    alignItems: 'center',
    marginTop: 10,
  },
  button: {
    alignItems: 'center',
    marginTop: 10,
  },
  update: {
    width: 140,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 15,
    flexDirection: 'row',
    marginHorizontal: 20,
  },
  textUpdate: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default TasksScreen;
