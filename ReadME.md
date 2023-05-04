# NEON DOCS

# Table Of Content

1. [Introduction](#introduction):: Purpose and features of our dApp 

2. [Technical Requirements](#technical)::: what is required to make use of the solution 

3. [Installation Instructions](#installation)::: necessary installation and initialization to be done before being able to integrate with the dApp 

4. [User Guide](#user):::

    i. Detail of the user interface of the dApp and how it can be used


    ii. how to subscribe to our insurance products

5. [Smart Contract Documentation](#smart)::: detail of the smart contract used by the dApp, including functions, parameters and event logs 

6. [Security:](#security):: security consideration of the dApp including possible vulnerabilities and how they can be addressed 

7. [Troubleshooting](#trouble)::: section on how to troubleshoot common issues that users may encounter while using the dApp 8. Glossary::: a glossary of terms used throughout the docs

## 01: INTRODUCTION <a name="introduction"></a>

**Insurance:** Insurance is a contract(policy), represented by a policy, in which a policyholder receives financial protection or reimbursement against losses from an insurance company. The company pools clients’ risks to make payments more affordable for the insured. Most people have some insurance: for their car, their house, their healthcare, or their life.

Insurance policies hedge against financial losses resulting from accidents, injury, or property damage. Insurance also helps cover costs associated with liability (legal responsibility) for damage or injury caused to a third party.

There are many types of insurance policies, including:

- Health Insurance: This covers the costs of medical and surgical expenses of the insured person.
- Life Insurance: This pays out a sum of money to the beneficiaries of the insured in the event of the insured's death.
- Property Insurance: This provides coverage against damage or loss of the insured's property, such as homes, vehicles, and personal belongings.
- Liability Insurance: This protects the insured against claims made against them by a third party for damages or injuries caused by the insured's actions.
- Disability Insurance: This provides income replacement to the insured in the event that they become disabled and unable to work.
- Travel Insurance: This provides coverage for unexpected expenses that may arise during travel, such as medical emergencies, trip cancellations, and lost luggage.
- Pet Insurance: This provides coverage for veterinary expenses and other costs related to caring for a pet.
- Business Insurance: This provides coverage for businesses against financial losses due to unexpected events such as property damage, liability claims, and business interruption.
- and lots more…

### Insurance Policy Components

Knowing how insurance functions can help in selecting a policy. For example, comprehensive auto insurance may not be the best fit for you. Premium, policy limit, and deductible are the three components that make up any insurance policy.

**Premium**

A policy’s premium is its price, typically a monthly cost. Often, an insurer takes multiple factors into account to set a premium. Here are a few examples:

- Auto insurance premiums: Your history of property and auto claims, age and location, creditworthiness, and many other factors that may vary by government decisions.
- Home insurance premiums: The value of your home, personal belongings, location, claims history, and coverage amounts.
- Health insurance premiums: Age, sex, location, health status, and coverage levels.
- Life insurance premiums: Age, sex, tobacco use, health, and amount of coverage.

Much depends on the insurer's perception of your risk for a claim.

**Policy Limit**

The policy limit is the maximum amount an insurer will pay for a covered loss under a policy. Maximums may be set per period (e.g., annual or policy term), per loss or injury, or over the life of the policy, also known as the lifetime maximum.

Typically, higher limits carry higher premiums. For a general life insurance policy, the maximum amount that the insurer will pay is referred to as the face value. This is the amount paid to your beneficiary upon your death.

**Deductible**

The deductible is a specific amount you pay out of pocket before the insurer pays a claim. Deductibles serve as deterrents to large volumes of small and insignificant claims.

For example, a $1,000 deductible means you pay the first $1,000 toward any claims. Suppose your car's damage totals $2,000. You pay the first $1,000, and your insurer pays the remaining $1,000.

Deductibles can apply per policy or claim, depending on the insurer and the type of policy. Health plans may have an individual deductible and a family deductible. Policies with high deductibles are typically less expensive because the high out-of-pocket expense generally results in fewer small claims.

> NB: This project at the moment basically looks into Health insurance for a start, as plans are underway for Auto insurance and other policies in the nearest future.

### Purpose of this Project

The purpose of this project is to implement a blockchain-based insurance system that provides the same benefits as traditional insurance but with enhanced security, transparency, and efficiency. The project aims to leverage the potential of the Ethereum blockchain to create a decentralized platform that eliminates the need for intermediaries and increases trust between parties.

The current insurance industry is plagued with issues such as fraud, data breaches, and delays in processing claims. By using blockchain technology, we aim to solve these problems by creating a transparent and immutable system that can prevent fraud and reduce the time required to process claims.

Our project will benefit the insurance industry by providing a secure and efficient way to store and manage customer data, as well as reducing the costs associated with intermediaries. Additionally, it will provide customers with greater control over their policies, faster claims processing, and lower premiums.

In summary, the purpose of this project is to revolutionize the insurance industry by providing a secure and efficient blockchain-based solution that offers significant advantages over traditional insurance.

### Features of the project

The following are the features of the project

1. Decentralized platform: The dApp would be built on the Ethereum blockchain, allowing for decentralized transactions and removing the need for a centralized authority.
2. Smart contracts: Smart contracts can be utilized to automate the insurance process, including premium payments, claims processing, and payouts.
3. Immutable data storage: By using blockchain technology, data can be stored in a decentralized and immutable way, ensuring data security and permanence.
4. Transparency: With blockchain technology, all transactions and activities on the platform can be tracked and verified, promoting transparency in the insurance process.
5. Efficient claims processing: Smart contracts can automate the claims process, ensuring quick and efficient payouts to customers.
6. Lower costs: By eliminating the need for intermediaries and reducing administrative costs, the dApp can provide insurance at a lower cost.
7. Easy access: The dApp can be accessed by anyone with an internet connection, providing easy access to insurance services.
8. Decentralized decision-making: Our dApp utilizes a DAO to enable decentralized decision-making for the insurance system. This means that members of the DAO can vote on whether to approve or reject insurance claims, rather than relying on a central authority. This helps to ensure a fair and transparent claims process that is less susceptible to corruption or bias.

## 02: TECHNICAL REQUIREMENTS <a name="technical"></a>

1. Background knowledge of web3: Provide an overview of what web3 is and how it relates to blockchain technology. Explain the key concepts such as decentralization, immutability, and smart contracts.
2. Ethereum Blockchain: Provide a brief overview of the Ethereum blockchain and how it differs from other blockchains. Explain the role of Ethereum in the context of your dApp.
3. Etherscan: Explain what Etherscan is and how it can be used to explore and monitor activity on the Ethereum blockchain. Provide a step-by-step guide on how to use Etherscan to check transactions, view smart contracts, and track token balances.
4. Wallet & Wallet Address: Explain the concept of a wallet and why it is necessary to interact with the Ethereum blockchain. Explain how to create a wallet, how to access it, and how to securely store the private key.
5. Metamask: Provide an overview of Metamask, a popular Ethereum wallet, and how it can be used to interact with the Ethereum blockchain. Provide a step-by-step guide on how to install and use Metamask to send and receive Ether and interact with dApps.
6. Purchasing Tokens: Explain how to purchase tokens using a cryptocurrency exchange or a decentralized exchange (DEX). Provide a step-by-step guide on how to connect your wallet to the exchange and how to purchase tokens securely.
7. How a Typical Blockchain Application Works: Provide an overview of how a typical blockchain application works, including the roles of miners, nodes, and users. Explain the transaction process and how smart contracts are used to automate business logic.
8. Lodging Complaints and Avoiding Scams: Provide tips on how to avoid scams and how to lodge complaints if you encounter any issues with the dApp. Explain the importance of doing due diligence and verifying the authenticity of any claims or promotions.

## 03: INSTALLATION INSTRUCTIONS <a name="installation"></a>

Here are the necessary installation and initialization to be done before being able to integrate with the dApp

1. Install a Web3-enabled browser extension such as MetaMask on your desktop or mobile device.
2. Create a new Ethereum wallet or import an existing one into MetaMask. Ensure you have sufficient funds in your wallet to perform transactions on the Ethereum network.
3. Navigate to the dApp website, Open the dApp in your browser and connect your MetaMask wallet to the application.
4. Allow the application to access your wallet, and confirm the connection in MetaMask.

> a good practice to provide screenshots or step-by-step tutorials to guide users through the installation process.

## 04: USER GUIDE <a name="user"></a>

1.  User Interface

In this section, we will provide a detailed guide on how to use the user interface of the dApp. This will include information on the different features of the dApp, such as:

- _Landing Page_: this is the page that welcomes you as you access the insurance platform for new and returning users, provides a stress-free experience for all visitors as it converts easily to provide the best experience you ever can imagine, with a button that allows you begin interaction almost immediately by connecting your wallet and following the prompts
- _Dashboard_: This is the main page of the dApp that is personal to individual users, where users can view their account details, insurance policies(cover) purchased, current insurance policies, make changes to their policies, and add new policies, renew cover, claims history, and other relevant information to each user,
- _Insurance_: here, we have a step-by-step guide on how users can subscribe to our insurance products. This will include information on

1. The different insurance products(_cover_) we offer, their features, and benefits.
2. How to choose the right insurance product for your needs.
3. How to fill out the necessary forms and provide the required documentation.
4. How to make payments and activate your insurance policy.

- _Invest_: a page under development at the time of compiling this doc! intended for allowing the investors and new admin to join the community i.e the DAO and other issues as it relates to the DAO
- _Governance_: a special page only for the members of the Decentralised Autonomous Organisation (DAO) used exclusively for two purposes:

1. to create insurance cover that is to be displayed on the insurance page for customers consumption and
2. To create a proposal of any sort relevant to the community for voting to enable consensus attainment.

_02. Buy Token_: this section will provide a step-by-step guide on how to buy the platform’s native token for intending DAO members and for a spectrum of other purposes.

> We will also provide screenshots and illustrations to make it easier for users to navigate the dApp.

At the end of the page, we have the footer which can help the user out in navigating the page and also provide information on how users can contact our support team if they need any assistance during the subscription process.

## 05: THE SMART CONTRACT <a name="smart"></a>

used by the dApp is an essential part of the insurance system. It defines the rules for managing policies, processing claims, and distributing payouts. This chapter provides detailed documentation for the smart contract, including its functions, parameters, and event logs.

**I. Functions**

The smart contract which serves as the backend for the dApp has the following functions:

createPolicy: This function is used to create a new insurance policy. It takes the policy details, including the policyholder's address, the type of policy, and the premium amount.

processClaim: This function is used to process a claim made by a policyholder. It takes the claim details, including the policy ID, the amount claimed, and the reason for the claim.

approveClaim: This function is used by the claims committee to approve or reject a claim. It takes the claim ID and the committee's decision.

payOut: This function is used to distribute the payout to the policyholder after a claim is approved. It takes the policy ID and the payout amount.

getPolicyDetails: This function is used to retrieve the details of a policy. It takes the policy ID and returns the policy details.

getClaimDetails: This function is used to retrieve the details of a claim. It takes the claim ID and returns the claim details.

**II. Parameters**

The smart contract uses the following parameters:

Policy ID: This is a unique identifier for each policy.

Claim ID: This is a unique identifier for each claim.

Policyholder: This is the address of the policyholder.

Premium Amount: This is the amount paid by the policyholder as a premium.

Claim Amount: This is the amount claimed by the policyholder.

Reason for Claim: This is the reason for the claim.

Committee Decision: This is the decision of the claims committee on a claim.

Payout Amount: This is the amount paid out to the policyholder after a claim is approved.

**III. Event Logs**

The smart contract logs the following events:

Policy Created: This event is logged when a new policy is created.

Claim Filed: This event is logged when a claim is filed.

Claim Approved: This event is logged when a claim is approved.

Payout Made: This event is logged when a payout is made.

Policy Details Retrieved: This event is logged when the details of a policy are retrieved.

Claim Details Retrieved: This event is logged when the details of a claim are retrieved.

This concludes the documentation for the smart contract used by the dApp. Understanding the smart contract is essential for anyone looking to understand how the platform works and process information under the hood.

## 06: SECURITY <a name="security"></a>

…security considerations for the dApp:

As with any blockchain application, security is of utmost importance. In this chapter, we will discuss the possible vulnerabilities that the dApp may face and how they can be addressed.

One of the major security concerns in blockchain applications is smart contract vulnerabilities. Smart contracts are self-executing contracts with the terms of the agreement between buyer and seller being directly written into code. As such, any vulnerabilities in the code could potentially be exploited, leading to financial losses for users of the dApp.

To mitigate these vulnerabilities, we have taken several measures to ensure the security of the dApp. Firstly, we have conducted thorough testing and auditing of the smart contract code to identify and fix any potential vulnerabilities.

Additionally, we have implemented access control mechanisms to restrict unauthorized access to sensitive parts of the dApp. This includes implementing multi-factor authentication and role-based access control to ensure that only authorized individuals have access to critical functions.

Furthermore, we have also implemented encryption techniques to protect sensitive data, such as user information and transaction data, from unauthorized access.

Lastly, we encourage our users to take necessary security measures on their end, such as using secure and trusted wallets, and not sharing their private keys with anyone.

Overall, we are committed to ensuring the security of our dApp and will continue to update and improve our security measures to mitigate any potential vulnerabilities.

## 07: Troubleshooting: <a name="trouble"></a>

- Common Error Messages: List of the common error messages users may encounter while using the dApp and steps to resolve them.
- Connectivity Issues: If users are having trouble connecting to the dApp, the following are instructions on possible ways to solve this issue.
- Wallet Issues: If the users are having issues relating to their wallet, the following is what can be tried to resolve the issue.
- Transaction Issues: in the event of any transaction issue please contact our customer support [here](#).
- Frequently Asked Questions (FAQ) [here](#)
