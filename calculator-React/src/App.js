import{useState} from 'react';

function App() {

	const[calc, setCalc] = useState("");
	const[result, setResult] = useState("");
	const ops = ['/','*','+','-','.'];
	const updateCalc = value => {
		if (
			ops.includes(value) && calc == '' 
			||
			ops.includes(value) && ops.includes(calc.slice(-1))
		){
			return;
		}

		setCalc(calc + value);

		if(!ops.includes(value)) {
			setResult(eval(calc + value).toString());
		}
	}
	const cn = () => {
		const num = [];
		
		for( let i = 1; i<10; i++){
			num.push(
				<button onClick={()=>updateCalc(i.toString())} key={i}> {i}</button>
			)
		}
		return num;
	}

	const delete1 = () => {
		if(calc == ''){
			return;
		}
		const value = calc.slice(0,-1);
		setCalc(value);
	}

	const calculate = () => {
		setCalc(eval(calc).toString());
	}
	
  return (
    <div className="App">
		<h1 className= "title1">Josia's Calculator using React</h1>
		<div className="Calculator">
			<div className="display">
				{ result ? <span>({result})</span> : '' }&nbsp; { calc||"0"}
			</div>
			<div className="Operators">
				<button onClick={()=>updateCalc('/')}>/</button>
				<button onClick={()=>updateCalc('*')}>*</button>
				<button onClick={()=>updateCalc('+')}>+</button>
				<button onClick={()=>updateCalc('-')}>-</button>
				<button onClick={delete1}>Delete</button>
			</div>
			<div class="number">
				{cn()}
				<button onClick={()=>updateCalc('0')}>0</button>
				<button onClick={()=>updateCalc('.')}>.</button>
				<button onClick={calculate}>=</button>
			</div>
		</div>
    </div>
  );
}

export default App;
