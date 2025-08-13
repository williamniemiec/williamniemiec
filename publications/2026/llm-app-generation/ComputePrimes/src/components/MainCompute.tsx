import React, { useState } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  TextInput,
  View,
  Button,
  ScrollView,
} from 'react-native';
import { RadioButton } from 'react-native-paper';
import { isPrime, findPrimesInRange, findNextPrime } from '../utils/primeCalculations';

const MainCompute = () => {
  const [inputValue, setInputValue] = useState('');
  const [operation, setOperation] = useState('check_primality');
  const [status, setStatus] = useState('Idle');
  const [result, setResult] = useState('');
  const [isCalculating, setIsCalculating] = useState(false);

  const handleExecute = () => {
    if (isCalculating) {
      return;
    }

    if (operation === 'check_primality' || operation === 'next_prime') {
      const num = parseInt(inputValue, 10);
      if (isNaN(num)) {
        setStatus('Error - Invalid Input');
        setResult("Error: Input must be a valid number.");
        return;
      }
    } else if (operation === 'find_primes') {
      const parts = inputValue.split('-');
      if (parts.length !== 2 || isNaN(parseInt(parts[0], 10)) || isNaN(parseInt(parts[1], 10))) {
        setStatus('Error - Invalid Input');
        setResult("Error: Range must be in 'start-end' format with numeric values.");
        return;
      }
    }

    setIsCalculating(true);
    setStatus('Calculating...');
    setResult('');

    // Run on the main thread to block UI
    setTimeout(() => {
      if (operation === 'check_primality') {
        const num = parseInt(inputValue, 10);
        const resultIsPrime = isPrime(num);
        setResult(`Result: ${num} is ${resultIsPrime ? '' : 'not '}a prime number.`);
      } else if (operation === 'find_primes') {
        const parts = inputValue.split('-');
        const start = parseInt(parts[0], 10);
        const end = parseInt(parts[1], 10);
        const primes = findPrimesInRange(start, end);
        setResult(`Primes in range ${start}-${end}: ${primes.join(', ')}`);
      } else if (operation === 'next_prime') {
        const num = parseInt(inputValue, 10);
        const nextPrime = findNextPrime(num);
        setResult(`The next prime after ${num} is ${nextPrime}.`);
      }
      setStatus('Complete');
      setIsCalculating(false);
    }, 100); // Use a short timeout to allow UI to update before blocking
  };

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>ComputePrime</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter number or range (e.g., 1-10000)"
        keyboardType="numbers-and-punctuation"
        value={inputValue}
        onChangeText={setInputValue}
        editable={!isCalculating}
      />
      <View style={styles.radioContainer}>
        <View style={styles.radioButton}>
          <RadioButton
            value="check_primality"
            status={operation === 'check_primality' ? 'checked' : 'unchecked'}
            onPress={() => setOperation('check_primality')}
            disabled={isCalculating}
          />
          <Text>Check Primality</Text>
        </View>
        <View style={styles.radioButton}>
          <RadioButton
            value="find_primes"
            status={operation === 'find_primes' ? 'checked' : 'unchecked'}
            onPress={() => setOperation('find_primes')}
            disabled={isCalculating}
          />
          <Text>Find Primes in Range</Text>
        </View>
        <View style={styles.radioButton}>
          <RadioButton
            value="next_prime"
            status={operation === 'next_prime' ? 'checked' : 'unchecked'}
            onPress={() => setOperation('next_prime')}
            disabled={isCalculating}
          />
          <Text>Calculate Next Prime</Text>
        </View>
      </View>
      <Button
        title="EXECUTE"
        onPress={handleExecute}
        disabled={isCalculating}
      />
      <Text style={styles.status}>Status: {status}</Text>
      <ScrollView style={styles.resultContainer}>
        <Text style={styles.resultText}>{result}</Text>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 20,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 20,
    paddingHorizontal: 10,
  },
  radioContainer: {
    marginBottom: 20,
  },
  radioButton: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  status: {
    marginTop: 20,
    fontSize: 16,
    textAlign: 'center',
  },
  resultContainer: {
    flex: 1,
    marginTop: 20,
    padding: 10,
    borderColor: 'gray',
    borderWidth: 1,
  },
  resultText: {
    fontSize: 16,
  },
});

export default MainCompute;