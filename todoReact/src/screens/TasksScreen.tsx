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
import {
  deleteTask,
  getTasks,
  postTask,
  putDate,
  putNameAndCategory,
  putPriority,
  putTaskDone,
} from '../crud/TasksCrud';
// @ts-ignore
import moment from 'moment';
import IconFa from 'react-native-vector-icons/FontAwesome';
import {getCategories} from '../crud/CategoriesCrud';
import {Task} from '../models/Task';
import {getPriorities} from '../crud/PrioritiesCrud';
import Swipeable from 'react-native-swipeable';
import {TextInput} from 'react-native-gesture-handler';
import LinearGradient from 'react-native-linear-gradient';
import Toast from 'react-native-simple-toast';
import DateTimePickerModal from 'react-native-modal-datetime-picker';
import type {PickerItem} from 'react-native-woodpicker';
import {Picker} from 'react-native-woodpicker';
import {Category} from '../models/Category';
import {Priority} from '../models/Priority';

const ToDoListsScreen = ({route, navigation}) => {
  const {colors} = useTheme();
  const [needUpdate, startUpdate] = useState(false);
  const [infoUpdateVisible, setInfoUpdateVisible] = useState(false);
  const [isDatePickerVisible, setDatePickerVisibility] = useState(false);
  const [addTaskVisible, setAddTaskVisible] = useState(false);
  const [sortVisible, setSortVisible] = useState(false);
  const [tasks, setTasks] = useState([]);
  const [categories, setCategories] = useState([]);
  const [priorities, setPriorities] = useState([]);
  const [taskName, setTaskName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<PickerItem>();
  const [selectedPriority, setSelectedPriority] = useState<PickerItem>();
  const [tempTask, setTempTask] = useState<Task>(new Task());
  const [sorting, setSorting] = useState({
    default: true,
    name: false,
    priority: false,
    dueDate: false,
  });

  useState(() => {
    getTasks().then(tasks => {
      setTasks(tasks);
    });
    getCategories().then(categories => {
      setCategories(categories);
    });
    getPriorities().then(priorities => {
      setPriorities(priorities);
    });
  });

  useEffect(() => {
    const unsubscribe = navigation.addListener(
      'focus',
      () => {
        getCategories().then(categories => {
          setCategories(categories);
        });
        getPriorities().then(priorities => {
          setPriorities(priorities);
        });
        return unsubscribe;
      },
      [navigation],
    );
  });

  useEffect(() => {
    if (needUpdate) {
      getTasks().then(tasks => {
        setTasks(tasks);
        startUpdate(false);
      });
    }
  });

  const categoryPickerItems = (categories: Category[]) => {
    let items: Array<PickerItem> = [];
    categories.forEach(category => {
      let item: PickerItem = {label: category.categoryName, value: category.id};
      items.push(item);
    });
    return items;
  };

  const priorityPickerItems = (priorities: Priority[]) => {
    let items: Array<PickerItem> = [];
    priorities.forEach(priority => {
      let item: PickerItem = {label: priority.priorityName, value: priority.id};
      items.push(item);
    });
    return items;
  };

  const getTasksScope = (tasks: Task[]) => {
    let output: Task[];
    if (route.params.id === 0) {
      output = tasks;
    } else {
      output = tasks.filter(task => task.todoCategoryId === route.params.id);
    }
    if (sorting.default === true) {
      output.sort((a, b) => a.createdDt.localeCompare(b.createdDt));
    }
    if (sorting.name === true) {
      output.sort((a, b) => a.taskName.localeCompare(b.taskName));
    }
    if (sorting.priority === true) {
      output.sort((a, b) => a.todoPriorityId.localeCompare(b.todoPriorityId));
    }
    if (sorting.dueDate === true) {
      let nullDates = output.filter(task => task.dueDt === null);
      let nonNullDates = output.filter(task => task.dueDt != null);
      nonNullDates.sort((a, b) => a.dueDt.localeCompare(b.dueDt));
      output = nonNullDates.concat(nullDates);
    }

    return output.sort(function (a, b) {
      return Number(a.isCompleted) - Number(b.isCompleted);
    });
  };

  const getItemCategory = (item: Task) => {
    let output = '';
    categories.forEach(element => {
      if (element.id === item.todoCategoryId) {
        output = element.categoryName;
      }
    });
    return output;
  };

  const getItemPriority = (item: Task) => {
    let output = <IconFa name="star-o" color={colors.text} size={20} />;
    priorities.forEach(priority => {
      if (
        priority.id === item.todoPriorityId &&
        priority.priorityName === 'Important'
      ) {
        output = <IconFa name="star" color="orange" size={20} />;
      }
    });
    return output;
  };

  const handleTaskCompleteness = (task: Task) => {
    putTaskDone(task).then(_ => startUpdate(true));
  };

  const handleTaskRemoval = (task: Task) => {
    deleteTask(task).then(_ => startUpdate(true));
  };

  const handlePriority = (task: Task) => {
    putPriority(task, priorities).then(_ => startUpdate(true));
  };

  const handleTaskUpdate = (
    task: Task,
    name: string,
    selectedCategory: PickerItem,
  ) => {
    let newCategoryId: string;
    if (!selectedCategory || selectedCategory.value === '') {
      newCategoryId = task.todoCategoryId;
    } else {
      newCategoryId = selectedCategory.value;
    }

    let newName: string;
    if (name.length < 1) {
      newName = task.taskName;
    } else {
      newName = name;
    }

    if (task.taskName === newName && task.todoCategoryId === newCategoryId) {
      setInfoUpdateVisible(false);
      Toast.show('Nothing changed');
    } else {
      setInfoUpdateVisible(false);
      putNameAndCategory(task, newName, newCategoryId).then(_ =>
        startUpdate(true),
      );
      setSelectedCategory({label: '', value: ''});
      setTaskName('');
    }
  };

  const handleTaskUpdateCancellation = () => {
    setInfoUpdateVisible(false);
    setSelectedCategory({label: '', value: ''});
    setTaskName('');
  };

  const handleAddTask = () => {
    let task = new Task();
    task.taskName = taskName;
    task.todoCategoryId = selectedCategory.value;
    task.todoPriorityId = selectedPriority.value;

    setAddTaskVisible(false);
    postTask(task).then(_ => startUpdate(true));
    setSelectedCategory({label: '', value: ''});
    setSelectedPriority({label: '', value: ''});
    setTaskName('');
    startUpdate(true);
  };

  const handleAddTaskCancellation = () => {
    setAddTaskVisible(false);
    setSelectedCategory({label: '', value: ''});
    setSelectedPriority({label: '', value: ''});
    setTaskName('');
    startUpdate(true);
  };

  const handleDueDateUpdate = (task: Task, date: Date) => {
    putDate(task, date).then(_ => startUpdate(true));
    setDatePickerVisibility(false);
  };

  const passToDescriptionUpdateModal = (task: Task) => {
    setTempTask(task);
    setInfoUpdateVisible(true);
  };

  const passToDateTimeModal = (task: Task) => {
    setTempTask(task);
    setDatePickerVisibility(true);
  };

  const dateTimeUpdateModal = (
    <DateTimePickerModal
      isVisible={isDatePickerVisible}
      date={tempTask.dueDt ? new Date(tempTask.dueDt) : new Date()}
      mode="datetime"
      onConfirm={date => {
        handleDueDateUpdate(tempTask, date);
      }}
      onCancel={() => setDatePickerVisibility(false)}
    />
  );

  const descriptionUpdateModal = (
    <Modal animationType="slide" transparent={true} visible={infoUpdateVisible}>
      <View style={{...styles.centeredView}}>
        <View style={{...styles.modalView, backgroundColor: colors.background}}>
          <Text style={{...styles.modalText, color: colors.text}}>
            Update Task...
          </Text>
          <Text style={{color: colors.text}}>
            set new name or category or both
          </Text>
          <View style={{...styles.action}}>
            <TextInput
              style={{...styles.textInput, color: colors.text}}
              onChangeText={value => setTaskName(value)}
              placeholder="Enter task description"
            />
          </View>
          <View style={{...styles.action}}>
            <Picker
              style={{...styles.picker}}
              item={selectedCategory}
              items={categoryPickerItems(categories)}
              onItemChange={setSelectedCategory}
              title="Select Category"
              placeholder="Select Category"
              isNullable
            />
          </View>
          <View
            style={{
              ...styles.modalButton,
            }}>
            <TouchableOpacity
              style={{...styles.update}}
              onPress={() => {
                handleTaskUpdate(tempTask, taskName, selectedCategory);
              }}>
              <LinearGradient
                colors={['#a749ff', '#1f00c4']}
                style={{...styles.update}}>
                <Text style={{...styles.textUpdate}}>Update</Text>
              </LinearGradient>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                handleTaskUpdateCancellation();
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

  const addTaskModal = (
    <Modal animationType="slide" transparent={true} visible={addTaskVisible}>
      <View style={{...styles.centeredView}}>
        <View style={{...styles.modalView, backgroundColor: colors.background}}>
          <Text style={{...styles.modalText, color: colors.text}}>
            Add New Task...
          </Text>
          <View style={{...styles.action, borderBottomWidth: 0}}>
            <Text style={{color: colors.text, fontSize: 16, marginTop: 20}}>
              Description{' '}
            </Text>
            <View style={{...styles.action}}>
              <TextInput
                style={{...styles.textInput, color: colors.text}}
                onChangeText={value => setTaskName(value)}
                placeholder="Enter task description"
              />
            </View>
          </View>
          <View
            style={{
              ...styles.action,
              alignItems: 'center',
              justifyContent: 'center',
            }}>
            <Picker
              style={{...styles.picker}}
              item={selectedCategory}
              items={categoryPickerItems(categories)}
              onItemChange={setSelectedCategory}
              title="Select Category"
              placeholder="Select Category"
              isNullable
            />
          </View>
          <View
            style={{
              ...styles.action,
              alignItems: 'center',
              justifyContent: 'center',
            }}>
            <Picker
              style={{...styles.picker, paddingHorizontal: 35}}
              item={selectedPriority}
              items={priorityPickerItems(priorities)}
              onItemChange={setSelectedPriority}
              title="Set Priority"
              placeholder="Set Priority"
              isNullable
            />
          </View>
          <View
            style={{
              ...styles.modalButton,
            }}>
            <TouchableOpacity
              style={{...styles.update}}
              onPress={() => {
                if (taskName.length < 1) {
                  Toast.show('Please enter task description!');
                } else if (!selectedCategory || selectedCategory.value === '') {
                  Toast.show('Please select category!');
                } else if (!selectedPriority || selectedPriority.value === '') {
                  Toast.show('Please set priority!');
                } else {
                  handleAddTask();
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
                handleAddTaskCancellation();
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

  const sortingModal = (
    <Modal animationType="slide" transparent={true} visible={sortVisible}>
      <View style={{...styles.centeredView}}>
        <View style={{...styles.modalView, backgroundColor: colors.background}}>
          <Text style={{...styles.modalText, color: colors.text}}>
            Sort by...
          </Text>
          <View
            style={{
              flexDirection: 'column',
              justifyContent: 'space-evenly',
            }}>
            <View
              style={{
                paddingVertical: 10,
              }}>
              <TouchableOpacity
                style={{
                  ...styles.update,
                  borderColor: '#6c00f8',
                  borderWidth: 1,
                }}
                onPress={() => {
                  setSorting({
                    ...sorting,
                    default: false,
                    name: false,
                    priority: true,
                    dueDate: false,
                  });
                  setSortVisible(false);
                }}>
                {sorting.priority ? (
                  <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                    Priority
                  </Text>
                ) : (
                  <LinearGradient
                    colors={['#a749ff', '#1f00c4']}
                    style={{...styles.update}}>
                    <Text style={{...styles.textUpdate}}>Priority</Text>
                  </LinearGradient>
                )}
              </TouchableOpacity>
            </View>
            <View
              style={{
                paddingVertical: 10,
              }}>
              <TouchableOpacity
                style={{
                  ...styles.update,
                  borderColor: '#6c00f8',
                  borderWidth: 1,
                }}
                onPress={() => {
                  setSorting({
                    ...sorting,
                    default: true,
                    name: false,
                    priority: false,
                    dueDate: false,
                  });
                  setSortVisible(false);
                }}>
                {sorting.default ? (
                  <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                    Creation Date
                  </Text>
                ) : (
                  <LinearGradient
                    colors={['#a749ff', '#1f00c4']}
                    style={{...styles.update}}>
                    <Text style={{...styles.textUpdate}}>Creation Date</Text>
                  </LinearGradient>
                )}
              </TouchableOpacity>
            </View>
            <View
              style={{
                paddingVertical: 10,
              }}>
              <TouchableOpacity
                style={{
                  ...styles.update,
                  borderColor: '#6c00f8',
                  borderWidth: 1,
                }}
                onPress={() => {
                  setSorting({
                    ...sorting,
                    default: false,
                    name: false,
                    priority: false,
                    dueDate: true,
                  });
                  setSortVisible(false);
                }}>
                {sorting.dueDate ? (
                  <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                    Due Date
                  </Text>
                ) : (
                  <LinearGradient
                    colors={['#a749ff', '#1f00c4']}
                    style={{...styles.update}}>
                    <Text style={{...styles.textUpdate}}>Due Date</Text>
                  </LinearGradient>
                )}
              </TouchableOpacity>
            </View>
            <View
              style={{
                paddingVertical: 10,
              }}>
              <TouchableOpacity
                style={{
                  ...styles.update,
                  borderColor: '#6c00f8',
                  borderWidth: 1,
                }}
                onPress={() => {
                  setSorting({
                    ...sorting,
                    default: false,
                    name: true,
                    priority: false,
                    dueDate: false,
                  });
                  setSortVisible(false);
                }}>
                {sorting.name ? (
                  <Text style={{...styles.textUpdate, color: '#6c00f8'}}>
                    Description
                  </Text>
                ) : (
                  <LinearGradient
                    colors={['#a749ff', '#1f00c4']}
                    style={{...styles.update}}>
                    <Text style={{...styles.textUpdate}}>Description</Text>
                  </LinearGradient>
                )}
              </TouchableOpacity>
            </View>
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
          setSortVisible(true);
        }}>
        <View
          style={{
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            marginLeft: 10,
          }}>
          <IconFa name="sort" color={'white'} size={25} />
          <Text style={{...styles.textUpdate, fontSize: 12}}>Sort</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={{...styles.update}}
        onPress={() => {
          setAddTaskVisible(true);
        }}>
        <View
          style={{
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            marginRight: 10,
          }}>
          <IconFa name="plus-circle" color={'white'} size={25} />
          <Text style={{...styles.textUpdate, fontSize: 12}}>Add</Text>
        </View>
      </TouchableOpacity>
    </View>
  );

  const renderItemView = (item: Task) => {
    const rightButtons = [
      <TouchableHighlight
        style={[styles.rightSwipeItem, {backgroundColor: 'green'}]}
        onPress={() => {
          handleTaskCompleteness(item);
        }}>
        <IconFa name="check-circle-o" color="white" size={35} />
      </TouchableHighlight>,
      <TouchableHighlight
        style={[styles.rightSwipeItem, {backgroundColor: 'red'}]}
        onPress={() => {
          handleTaskRemoval(item);
        }}>
        <IconFa name="times-circle-o" color="white" size={35} />
      </TouchableHighlight>,
    ];
    const importanceIndicator = (
      <TouchableOpacity
        onPress={() => {
          handlePriority(item);
        }}>
        {getItemPriority(item)}
      </TouchableOpacity>
    );

    const taskDescription = (
      <TouchableOpacity
        onPress={() => {
          passToDescriptionUpdateModal(item);
        }}>
        <View style={{...styles.description}}>
          {item.isCompleted ? (
            <Text style={{...styles.itemCompleted, color: colors.text}}>
              {item.taskName}
            </Text>
          ) : (
            <Text
              style={{
                ...styles.item,
                color: colors.text,
              }}>
              {item.taskName}
            </Text>
          )}
          <Text style={{color: colors.text}}>
            Category: {getItemCategory(item)}
          </Text>
        </View>
      </TouchableOpacity>
    );

    const dueDate = (
      <TouchableOpacity
        style={{flex: 1}}
        onPress={() => {
          passToDateTimeModal(item);
        }}>
        <View
          style={{
            ...styles.dueDateContainer,
          }}>
          {item.dueDt ? (
            <>
              <IconFa name="clock-o" color={colors.text} size={20} />
              <View
                style={{
                  ...styles.dueDate,
                }}>
                <Text style={{color: colors.text}}>
                  {moment(moment.utc(item.dueDt)).local().format('HH:mm')}
                </Text>
                <Text style={{color: colors.text}}>
                  {moment(moment.utc(item.dueDt)).local().format('DD.MM.YY')}
                </Text>
              </View>
            </>
          ) : (
            <Text style={{color: colors.text}}>Set Due Date</Text>
          )}
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
                {importanceIndicator}
                {taskDescription}
              </View>
              {dueDate}
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
          {route.params.name}
        </Text>
      </View>
      <View style={{...styles.listview}}>
        <FlatList
          data={getTasksScope(tasks)}
          renderItem={({item}) => renderItemView(item)}
          keyExtractor={item => item.id}
        />
      </View>
      {addTaskModal}
      {descriptionUpdateModal}
      {dateTimeUpdateModal}
      {sortingModal}
      <View style={{...styles.footerButtons}}>{footerButtons}</View>
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
    width: '100%',
  },
  item: {
    fontWeight: 'bold',
    fontSize: 18,
    width: '70%',
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
    justifyContent: 'center',
    alignItems: 'center',
  },
  titleText: {
    fontSize: 23,
    fontWeight: 'bold',
  },
  listview: {
    flex: 8,
    paddingHorizontal: 20,
    width: '100%',
  },

  description: {
    flexDirection: 'column',
    minWidth: '68%',
    marginLeft: 10,
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

export default ToDoListsScreen;
