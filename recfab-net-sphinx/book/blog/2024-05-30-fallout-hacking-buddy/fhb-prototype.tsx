import {useState} from 'react';
import clsx from 'clsx';
import styles from './fhb-prototype.module.css';

type CandidateStatus = 'correct' | 'active' | 'eliminated';
type Mask = string;

class Candidate {
  key: string;
  value: string;
  likeness: null | number;
  masks: Mask[];
  status: CandidateStatus;

  constructor(key: string, value: string){
    this.key = key;
    this.value = value;
    this.likeness = null;
    this.masks = [];
    this.status = 'active';
  }

  hasLikeness() {
    return Number.isInteger(this.likeness);
  }
}

interface Props {
  id: string;
  initialCorrectPassword: string;
  initialCandidatesInput: string;
}

function calcLikeness(a: string, b: string): number {
  let likeness = 0;
  for (var i = 0; i < a.length; i++){
    if (a[i] == b[i]) {
      likeness++;
    }
  }
  return likeness;
}

function calcMasks(candidate: Candidate): string[] {
  let candidateValue = candidate.value;
  let len = candidateValue.length;
  let start = new Array(len).fill('?').join('');

  // This involves a bunch of splitting a string into a character array then joining it back again.
  // I'm sure there is a more efficient way, but that's not the concern right now.

  function calc(prevMasks: Mask[], round: number, maxRound: number) {
    if (round > maxRound) {
      return prevMasks;
    }

    console.info('calculating masks', {prevMasks, round, maxRound})

    let currMasks = [];
    for (var i = 0; i < prevMasks.length; i ++){
      let baseMask = prevMasks[i];
      for (var j = 0; j < len; j++) {
        let maskArray = baseMask.split('')
        if (maskArray[j] == '?') {
          maskArray[j] = candidateValue[j];
          let mask = maskArray.join('')
          if (!currMasks.includes(mask)) {
            currMasks.push(mask)
          }
        }
      }
    }

    return calc(currMasks, round + 1, maxRound)
  }

  return calc([start], 1, candidate.likeness)
}

export default function FalloutHackingHelper({
  id,
  initialCorrectPassword,
  initialCandidatesInput
}){

  let [correctPassword, setCorrectPassword] = useState(initialCorrectPassword?.toUpperCase() ?? '')
  let [candidatesInput, setCandidatesInput] = useState(initialCandidatesInput ?? '')
  let [candidates, setCandidates] = useState([])
  let correctInputId = id + '-correct'
  let candidatesInputId = id + '-candidates'

  function handleCorrectInputChange(event){
    setCorrectPassword(event.target.value)
  }
  function handleCandidatesInputChange(event){
    setCandidatesInput(event.target.value)
  }


  function updateStatus(candidates: Candidate[])
  {
    let maxLikeness =  correctPassword.length;
    for (var i = 0; i < candidates.length; i++) {
      let candidate = candidates[i];
      // set status
      if (!candidate.hasLikeness()) {
        candidate.status = 'active';
        continue;
      }

      if (candidate.likeness == maxLikeness){
        candidate.status = 'correct'
      }
      else {
        candidate.status = 'eliminated'
      }

      // calculate possibilities
      candidate.masks = calcMasks(candidate);
    }
  }

  function revealLikeness(candidate: Candidate){
    console.info('Revealing likeness for', candidate)
    let likeness = calcLikeness(correctPassword, candidate.value)
    console.info('calculated likeness', { correctPassword, candidateValue: candidate.value, likeness})
    candidate.likeness = likeness;
    console.info('candidate', candidate)

    updateStatus(candidates)
    // This feels hacky, but I need it to re-render here
    setCandidates(candidates.map(x => x));
  }

  function handleButtonClick() {
    setCandidates(
      candidatesInput.split('\n')
        .map(function(v){
          return new Candidate(v, v.toUpperCase())
        }))
  }

  return (
    <div id={id} className={clsx(styles.board)}>
      <label htmlFor={correctInputId}>Correct password:</label>
      <input type="text"
        style={{display: 'block'}}
        value={correctPassword}
        onChange={handleCorrectInputChange} />
      <label htmlFor={candidatesInputId}>Enter possible passwords:</label>
      <textarea id={candidatesInputId}
        value={candidatesInput}
        onChange={handleCandidatesInputChange}
        style={{display: 'block'}}
        rows={10}
        >
      </textarea>
      <button className="button button--primary"
        onClick={handleButtonClick}
        >
          create board
        </button>
      <table>
        <thead>
          <tr>
            <th>Candidate</th>
            <th>Likeness</th>
            <th>Masks</th>
          </tr>
        </thead>
        <tbody>
          {candidates.map(function(c){
            return (
              <tr key={c.key}
                className={clsx(
                  styles.candidate,
                  styles[c.status])}>
                <td className={clsx(styles.value)}>{c.value}</td>
                <td>
                  {c.hasLikeness()
                    ? c.likeness
                    : <button className="button button--secondary"
                      onClick={() => revealLikeness(c)}
                    >
                      Reveal
                    </button> }
                </td>
                <td>
                  <ol>
                    {c.masks.map(function(m){
                      return <li key={m}>{m}</li>
                    })}
                  </ol>
                </td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  );
}

