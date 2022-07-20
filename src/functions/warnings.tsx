import { WarningProps } from '../components/warning';

export const connectWallet: WarningProps = {
    props: {
        photoURL: 'https://i.ibb.co/jgR5nn6/wallet.png',
        label: 'Connect your Wallet',
    }
};

export const connectNetwork: WarningProps = {
    props: {
        photoURL: 'https://i.ibb.co/Dt6sfXH/warning.png',
        // label: 'Please connect to Binance Smart Chain Testnet or Rinkeby Testnet',
        label: 'Please connect to C4EI or KLAY Mainnet',
    }
};

export const createNFT: WarningProps = {
    props: {
        // photoURL: 'https://i.ibb.co/QXdSnMh/SHH.png',
        photoURL: 'https://i.ibb.co/dKbPkVt/c4eix200t-Logo.png',
        label: "You don't have any NFT",
        button: {
            href: '/createNFT',
            label: 'Create NFT'
        }
    }
}