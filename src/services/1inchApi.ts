import axios from 'axios';

// 1inch API base URLs for different networks
const API_BASE_URLS = {
  ethereum: 'https://api.1inch.dev/swap/v6.0',
  baseSepolia: 'https://api.1inch.dev/swap/v6.0',
  polygonAmoy: 'https://api.1inch.dev/swap/v6.0'
};

// Chain IDs
export const CHAIN_IDS = {
  ethereum: 1,
  baseSepolia: 84532,
  polygonAmoy: 8002
};

// Token addresses for common tokens
export const TOKENS = {
  ethereum: {
    USDC: '0xA0b86a33E6441b8c4C8C8C8C8C8C8C8C8C8C8C8',
    WETH: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
    USDT: '0xdAC17F958D2ee523a2206206994597C13D831ec7'
  },
  baseSepolia: {
    USDC: '0x036CbD53842c5426634e7929541eC2318f3dCF7c',
    WETH: '0x4200000000000000000000000000000000000006',
    USDT: '0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb'
  },
  polygonAmoy: {
    USDC: '0x9999f7Fea5938fD3b1C26C66D0053E4c8e8c8c8c8',
    WETH: '0x4200000000000000000000000000000000000006',
    USDT: '0x50c5725949A6F0c72E6C4a641F24049A917DB0Cb'
  }
};

class OneInchAPI {
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  // Get quote for token swap
  async getQuote(
    fromTokenAddress: string,
    toTokenAddress: string,
    amount: string,
    chainId: number
  ) {
    try {
      const response = await axios.get(`${API_BASE_URLS.ethereum}/${chainId}/quote`, {
        params: {
          src: fromTokenAddress,
          dst: toTokenAddress,
          amount: amount,
          includeTokensInfo: true,
          includeProtocols: true,
          includeGas: true
        },
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'application/json'
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error getting quote:', error);
      throw error;
    }
  }

  // Get swap transaction data
  async getSwap(
    fromTokenAddress: string,
    toTokenAddress: string,
    amount: string,
    fromAddress: string,
    slippage: number = 1,
    chainId: number
  ) {
    try {
      const response = await axios.get(`${API_BASE_URLS.ethereum}/${chainId}/swap`, {
        params: {
          src: fromTokenAddress,
          dst: toTokenAddress,
          amount: amount,
          from: fromAddress,
          slippage: slippage,
          includeTokensInfo: true,
          includeProtocols: true,
          includeGas: true
        },
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'application/json'
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error getting swap:', error);
      throw error;
    }
  }

  // Get token list for a chain
  async getTokens(chainId: number) {
    try {
      const response = await axios.get(`${API_BASE_URLS.ethereum}/${chainId}/tokens`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'application/json'
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error getting tokens:', error);
      throw error;
    }
  }

  // Get protocols for a chain
  async getProtocols(chainId: number) {
    try {
      const response = await axios.get(`${API_BASE_URLS.ethereum}/${chainId}/protocols`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'application/json'
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error getting protocols:', error);
      throw error;
    }
  }
}

// Create instance with API key (you'll need to get this from 1inch)
export const oneInchAPI = new OneInchAPI(import.meta.env.VITE_1INCH_API_KEY || 'your-api-key-here');

export default OneInchAPI; 