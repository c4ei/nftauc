import React from 'react'
import type { NextPage } from 'next'
import Head from 'next/head'
import { NavBar } from '../src/components/navBar'
import { theNavBar } from '../src/functions/navBar'
import { Box } from '@chakra-ui/react';
import { MyNFTs } from '../src/components/myNFTs'

const Home: NextPage = () => {
  return (
    <>
      <Head>
        <title>C4EI NFT Auction</title>
        <meta name="description" content="In this dapp you can create your own NFT, buy NFT from other users and also sell your NFTs." />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <NavBar {...theNavBar}/>
      <Box h='75px' />
      <MyNFTs />
    </>
  )
}

export default Home
