import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type TransactionId = Nat;
  
  type Transaction = {
    id: TransactionId;
    category: Text;
    amount: Nat;
    isIncome: Bool;
    date: Time.Time;
  };

  var transactions = Buffer.Buffer<Transaction>(0);

  public func addTransaction(category: Text, amount: Nat, isIncome: Bool) : async TransactionId {
    let transactionId = transactions.size();
    let newTransaction: Transaction = {
      id = transactionId;
      category = category;
      amount = amount;
      isIncome = isIncome;
      date = Time.now();
    };
    transactions.add(newTransaction);
    transactionId
  };

  public query func getTransaction(transactionId: TransactionId) : async ?Transaction {
    if (transactionId < transactions.size()) {
      ?transactions.get(transactionId)
    } else {
      null
    };
  };

  public query func getAllTransactions() : async [Transaction] {
    Buffer.toArray(transactions)
  };

  public query func getBalance() : async Int {
    var balance = 0;
    for (transaction in transactions.vals()) {
      if (transaction.isIncome) {
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      };
    };
    balance
  };

  public query func getTransactionsByCategory(category: Text) : async [Transaction] {
    let filtered = Buffer.Buffer<Transaction>(0);
    for (transaction in transactions.vals()) {
      if (Text.equal(transaction.category, category)) {
        filtered.add(transaction);
      };
    };
    Buffer.toArray(filtered)
  };
};