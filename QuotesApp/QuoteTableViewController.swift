//
//  QuoteTableViewController.swift
//  QuotesApp
//
//  Created by  Stepanok Ivan on 11.08.2021.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {

    
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    
    let productID = "stepanok.com.QuotesApp"
    
    
    var quotes = [
    "Лучше быть последним – первым, чем первым – последним.",
    "Кем бы ты ни был, кем бы ты не стал, помни, где ты был и кем ты стал.",
        "Если волк молчит то лучше его не перебивать.",
        "Делай как надо, как не надо не делай.",
        "Работа не волк, работа это ворк, а волк это ходить.",
        "Брат уйдёт от брата только если звонок на урок."
    ]
    
    let premiumQuotes = [
    "Волк никогда не будет жить в загоне, но загоны всегда будут жить в волке.",
        "Если волк вас любит он никогда не даст вас в обиду! Он будет обижать вас сам.",
        "Волк не тот кто охотиться один, а тот кто охотиться два.",
        "С каждым шагом ты на шаг дальше.",
        "Сильный тот, у кого силы есть.",
        "Если напротив “волк”, то волк по-настоящему есть волк!",
        "За двумя зайцами погонишься — рыбку из пруда не выловишь, делу время, а отмеришь семь раз…",
        "Каждый думает, что не знает что, но не каждый не знает, что знает, кто не я …",
        "Иногда жизнь — это жизнь, а ты в ней иногда.",
        "В жизни полно лжи и грязи, она не так красива. Даже твой лучший друг может не поделиться пивом…"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Если пользователь купил премиум, то запускаем функцию с добавлением премиум контента.
        if isPurchased() == true {
            showPremium()
        }
        
        // Фоновое изображение для табличного представления
        let tempImageView = UIImageView(image: UIImage(named: "wolf"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
        // Запускаем делегат класса SKPaymentTransactionObserver
        SKPaymentQueue.default().add(self)
        
    }

    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if quotes.count != indexPath.row {
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = quotes[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        } else {
            // Скрываем кнопочку "Ещё больше цитат" если уже куплено.
            if isPurchased() != true {
            cell.textLabel?.text = "Ещё больше цитат"
            cell.textLabel?.textColor = .systemBlue
            cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        
    }
    
    // Запускаем функцию покупки если пользователь нажимает по последней табличке
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if quotes.count == indexPath.row {
            print("Приветики")
            buyMoreQuotes()
            
           
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // Покупка совершается тут
    func buyMoreQuotes() {
        if SKPaymentQueue.canMakePayments() {
            print("Можешь покупать деньги")
            
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
            
            
        } else {
            print("Тебе ещё рано покупать деньги, Волк")
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transtaction in transactions {
            if transtaction.transactionState == .purchased {
                // Покупка успешна
                print("Покупка совершена успешна, Волк")
                
                showPremium()

                
                SKPaymentQueue.default().finishTransaction(transtaction)
                
            } else if transtaction.transactionState == .failed {
                // Покупка не прошла
                print("У Волка нет денег")
                
                if let error = transtaction.error {
                    print(error.localizedDescription)
                }
                
                SKPaymentQueue.default().finishTransaction(transtaction)

            } else if transtaction.transactionState == .restored {
                print("Волк восстановил свои покупки")
                showPremium()
                
                
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transtaction)
            }
        }
        
    }
    
    
    // Отображаем премиум контент
    func showPremium() {
        UserDefaults.standard.set(true, forKey: productID)

        self.quotes.append(contentsOf: premiumQuotes)
        tableView.reloadData()

    }
    
    // Проверка, купил ли пользователь премиум
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        if purchaseStatus {
            return true
        } else {
            return false
        }
    }
    

}
