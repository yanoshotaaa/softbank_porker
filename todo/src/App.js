import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  // ローカルストレージから初期値を取得
  const [todos, setTodos] = useState(() => {
    const saved = localStorage.getItem('todos');
    if (!saved) return [];
    // subTodosが無い場合は空配列をセット
    return JSON.parse(saved).map(todo => ({
      ...todo,
      subTodos: todo.subTodos || []
    }));
  });
  const [input, setInput] = useState('');
  const [sortType, setSortType] = useState('default'); // 並び替え状態
  const [subInputs, setSubInputs] = useState({}); // サブタスク入力用

  // todosが変わるたびにローカルストレージへ保存
  useEffect(() => {
    localStorage.setItem('todos', JSON.stringify(todos));
  }, [todos]);

  // 新しいIDを生成
  const generateId = () => '_' + Math.random().toString(36).substr(2, 9);

  const handleAddTodo = (e) => {
    e.preventDefault();
    if (input.trim() === '') return;
    setTodos([
      ...todos,
      {
        id: generateId(),
        text: input,
        checked: false,
        date: new Date().toISOString().slice(0, 10),
        subTodos: []
      }
    ]);
    setInput('');
  };

  const handleToggleCheck = (id) => {
    setTodos(
      todos.map((todo) =>
        todo.id === id
          ? {
              ...todo,
              checked: !todo.checked,
              subTodos: todo.subTodos.map((sub) => ({ ...sub, checked: !todo.checked })),
            }
          : todo
      )
    );
  };

  const handleDeleteTodo = (id) => {
    setTodos(todos.filter((todo) => todo.id !== id));
  };

  // サブタスク追加
  const handleAddSubTodo = (parentId, e) => {
    e.preventDefault();
    const subText = subInputs[parentId] || '';
    if (subText.trim() === '') return;
    setTodos(
      todos.map((todo) =>
        todo.id === parentId
          ? {
              ...todo,
              subTodos: [
                ...todo.subTodos,
                { id: generateId(), text: subText, checked: false },
              ],
            }
          : todo
      )
    );
    setSubInputs({ ...subInputs, [parentId]: '' });
  };

  // サブタスクのチェック切替
  const handleToggleSubCheck = (parentId, subId) => {
    setTodos(
      todos.map((todo) => {
        if (todo.id !== parentId) return todo;
        const newSubTodos = todo.subTodos.map((sub) =>
          sub.id === subId ? { ...sub, checked: !sub.checked } : sub
        );
        // サブタスクが全てチェックなら親もチェックON、1つでもOFFなら親もOFF
        const allChecked = newSubTodos.length > 0 && newSubTodos.every((sub) => sub.checked);
        return {
          ...todo,
          subTodos: newSubTodos,
          checked: allChecked,
        };
      })
    );
  };

  // サブタスク削除
  const handleDeleteSubTodo = (parentId, subId) => {
    setTodos(
      todos.map((todo) => {
        if (todo.id !== parentId) return todo;
        const newSubTodos = todo.subTodos.filter((sub) => sub.id !== subId);
        // サブタスクが全てチェックなら親もチェックON、1つでもOFFなら親もOFF
        const allChecked = newSubTodos.length > 0 && newSubTodos.every((sub) => sub.checked);
        return {
          ...todo,
          subTodos: newSubTodos,
          checked: allChecked,
        };
      })
    );
  };

  // 並び替えロジック
  const getSortedTodos = () => {
    if (sortType === 'checked') {
      return [...todos].sort((a, b) => a.checked - b.checked);
    } else if (sortType === 'date') {
      // dateが無い場合は空文字列で比較
      return [...todos].sort((a, b) => (a.date || '').localeCompare(b.date || ''));
    }
    return todos;
  };

  // 進捗率計算
  const getProgress = () => {
    let total = 0, done = 0;
    todos.forEach(task => {
      total++;
      if (task.checked) done++;
      if (task.subTodos && task.subTodos.length > 0) {
        total += task.subTodos.length;
        done += task.subTodos.filter(sub => sub.checked).length;
      }
    });
    return total === 0 ? 0 : Math.round((done / total) * 100);
  };

  return (
    <div className="App">
      <h1>Todoアプリ</h1>
      <div className="progress-bar-wrap">
        <div className="progress-label">進捗: {getProgress()}%</div>
        <div className="progress-bar-bg">
          <div className="progress-bar-fg" style={{width: getProgress() + '%'}}></div>
        </div>
      </div>
      <form onSubmit={handleAddTodo}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="新しいタスクを入力"
        />
        <button type="submit">追加</button>
      </form>
      <div style={{ margin: '10px 0' }}>
        <button onClick={() => setSortType('default')}>元の順</button>
        <button onClick={() => setSortType('checked')}>チェック有無で並び替え</button>
        <button onClick={() => setSortType('date')}>日付で並び替え</button>
      </div>
      <ul>
        {getSortedTodos().map((todo) => (
          <li key={todo.id} style={{ marginBottom: '16px' }} className={todo.checked ? 'checked' : ''}>
            <input
              type="checkbox"
              checked={todo.checked}
              onChange={() => handleToggleCheck(todo.id)}
            />
            <div className="task-main">
              <span style={{ textDecoration: todo.checked ? 'line-through' : 'none' }}>
                {todo.text}
              </span>
              <span className="todo-date">{todo.date}</span>
              <button onClick={() => handleDeleteTodo(todo.id)}>削除</button>
            </div>
            {/* サブタスク表示・追加 */}
            <ul style={{ marginLeft: '24px' }}>
              {todo.subTodos.map((sub) => (
                <li key={sub.id}>
                  <input
                    type="checkbox"
                    checked={sub.checked}
                    onChange={() => handleToggleSubCheck(todo.id, sub.id)}
                  />
                  <span style={{ textDecoration: sub.checked ? 'line-through' : 'none' }}>
                    {sub.text}
                  </span>
                  <button onClick={() => handleDeleteSubTodo(todo.id, sub.id)}>削除</button>
                </li>
              ))}
              <li>
                <form onSubmit={(e) => handleAddSubTodo(todo.id, e)} style={{ display: 'inline' }}>
                  <input
                    type="text"
                    value={subInputs[todo.id] || ''}
                    onChange={(e) => setSubInputs({ ...subInputs, [todo.id]: e.target.value })}
                    placeholder="サブタスク追加"
                  />
                  <button type="submit">追加</button>
                </form>
              </li>
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
