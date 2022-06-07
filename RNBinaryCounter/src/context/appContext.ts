import React from 'react';

export interface IAppContext {
  counter: number,
  updateCounter: (change: number) => void;
  getBit: (counter: number, BitNo: number) => number;
}

const emptyFunction = () => {}

export const initialContext: IAppContext = {
  counter: 5,
  updateCounter: emptyFunction,

  getBit: (counter: number, bitNo: number) => {
    let bitNo2 = Math.floor(counter / 4);
    let bitNo1 = Math.floor((counter - bitNo2 * 4) / 2);
    let bitNo0 = Math.floor(counter - bitNo2 * 4 - bitNo1 * 2);
    switch (bitNo) {
      case 2:
        return bitNo2;
      case 1:
        return bitNo1;
      case 0:
        return bitNo0;
    }
    return 9;
  }
}

export const AppContext = React.createContext<IAppContext>(initialContext);
export const AppContextProvider = AppContext.Provider;
export const AppContextConsumer = AppContext.Consumer;
