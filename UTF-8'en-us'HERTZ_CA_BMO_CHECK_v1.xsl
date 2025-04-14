<?xml version='1.0' encoding='utf-8'?>
<!--
Template name:	UTF-8'en-us'HERTZ_CA_BMO_CHECK_v1.xsl
Author:			Anirban Mukherjee
Version:		1
Release Date:	2024/11/12
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no"/>
	<xsl:output method="xml"/>
	<xsl:key name="contacts-by-LogicalGroupReference" match="OutboundPayment" use="LogicalGrouping/LogicalGroupReference"/>
	<xsl:template match="OutboundPaymentInstruction">
		<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:variable name="instrid" select="PaymentInstructionInfo/InstructionReferenceNumber"/>
			<xsl:variable name="profName" select="PaymentProcessProfile/PaymentProcessProfileName"/>
			<CstmrCdtTrfInitn>
				<GrpHdr>
					<MsgId>
						<xsl:value-of select="$instrid"/>
					</MsgId>
					<CreDtTm>
						<xsl:value-of select="substring-before(PaymentInstructionInfo/InstructionCreationDate,'+')"/>
					</CreDtTm>
					<NbOfTxs>
						<xsl:value-of select="InstructionTotals/PaymentCount"/>
					</NbOfTxs>
					<CtrlSum>
						<xsl:value-of select="format-number(InstructionTotals/TotalPaymentAmount/Value,'#.00')"/>
					</CtrlSum>
					<InitgPty>
						<Nm>
							<xsl:value-of select="InstructionGrouping/Payer/Name"/>
						</Nm>
						<Id>
							<OrgId>
								<Othr>
									<Id>10006014</Id>
								</Othr>
							</OrgId>
						</Id>
					</InitgPty>
				</GrpHdr>
				<xsl:for-each select="OutboundPayment[count(. | key('contacts-by-LogicalGroupReference', PaymentNumber/LogicalGroupReference)[1]) = 1]">
					<xsl:sort select="PaymentNumber/LogicalGroupReference"/>
					<PmtInf>
						<PmtInfId>
							<xsl:value-of select="PaymentNumber/CheckNumber"/>
						</PmtInfId>
						<PmtMtd>CHK</PmtMtd>
						<NbOfTxs>
							<xsl:value-of select="count(DocumentPayableCount)"/>
						</NbOfTxs>
						<CtrlSum>
							<xsl:value-of select="format-number(PaymentAmount/Value,'#.00')"/>
						</CtrlSum>
						<PmtTpInf>
							<LclInstrm>
								<Prtry>CHK</Prtry>
							</LclInstrm>
						</PmtTpInf>
						<ReqdExctnDt>
							<xsl:choose>
								<xsl:when test="(Extend/ExecutionDate!='')">
									<xsl:value-of select="Extend/ExecutionDate"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="PaymentDate"/>
								</xsl:otherwise>
							</xsl:choose>
						</ReqdExctnDt>
						<Dbtr>
							<Nm>
								<xsl:value-of select="Payer/Name"/>
							</Nm>
							<PstlAdr>
								<StrtNm>
									<xsl:value-of select="Payer/Address/AddressLine1"/>
								</StrtNm>
								<xsl:if test="not(Payer/Address/AddressLine2='')">
									<BldgNb>
										<xsl:value-of select="substring(Payer/Address/AddressLine2, 1, 16)"/>
									</BldgNb>
								</xsl:if>
								<PstCd>
									<xsl:value-of select="Payer/Address/PostalCode"/>
								</PstCd>
								<TwnNm>
									<xsl:value-of select="Payer/Address/City"/>
								</TwnNm>
								<CtrySubDvsn>
									<xsl:value-of select="Payer/Address/Province"/>
								</CtrySubDvsn>
								<Ctry>
									<xsl:value-of select="Payer/Address/Country"/>
								</Ctry>
							</PstlAdr>
							<Id>
								<OrgId>
									<Othr>
										<Id>3006985196</Id>
										<SchmeNm>
											<Prtry>BMOCOID</Prtry>
										</SchmeNm>
									</Othr>
								</OrgId>
							</Id>
						</Dbtr>
						<DbtrAcct>
							<Id>
								<Othr>
									<Id>
										<xsl:value-of select="substring(BankAccount/BankAccountNumber, 5, 7 ) "/>
									</Id>
								</Othr>
							</Id>
						</DbtrAcct>
						<DbtrAgt>
							<FinInstnId>
								<ClrSysMmbId>
									<MmbId>000100022</MmbId>
								</ClrSysMmbId>
							</FinInstnId>
						</DbtrAgt>
						<xsl:variable name="paymentdetails" select="PaymentDetails"/>
						<CdtTrfTxInf>
							<PmtId>
								<InstrId>
									<xsl:value-of select="PaymentNumber/CheckNumber"/>
								</InstrId>
								<EndToEndId>
									<xsl:value-of select="PaymentNumber/CheckNumber"/>
								</EndToEndId>
							</PmtId>
							<Amt>
								<InstdAmt>
									<xsl:attribute name="Ccy">
										<xsl:value-of select="PaymentAmount/Currency/Code"/>
									</xsl:attribute>
									<xsl:value-of select="format-number(PaymentAmount/Value,'#.00')"/>
								</InstdAmt>
							</Amt>
							<ChqInstr>
									<ChqNb>
										<xsl:value-of select="PaymentNumber/CheckNumber"/>
									</ChqNb>
									<xsl:if test="contains($profName, '_SH')">
										<DlvryMtd>
											<Prtry>01</Prtry>
										</DlvryMtd>
									</xsl:if>
							</ChqInstr>
							<Cdtr>
								<Nm>
									<xsl:value-of select="Payee/Name"/>
								</Nm>
								<PstlAdr>
									<StrtNm>
										<xsl:value-of select="Payee/Address/AddressLine1"/>
									</StrtNm>
									<xsl:if test="not(Payee/Address/AddressLine2='')">
										<BldgNb>
											<xsl:value-of select="substring(Payee/Address/AddressLine2, 1, 16)"/>
										</BldgNb>
									</xsl:if>
									<PstCd>
										<xsl:value-of select="Payee/Address/PostalCode"/>
									</PstCd>
									<TwnNm>
										<xsl:value-of select="Payee/Address/City"/>
									</TwnNm>
									<CtrySubDvsn>
										<xsl:value-of select="Payee/Address/State"/>
									</CtrySubDvsn>
									<Ctry>
										<xsl:value-of select="Payee/Address/Country"/>
									</Ctry>
								</PstlAdr>
								<Id>
									<OrgId>
										<Othr>
											<Id>
												<xsl:value-of select="Payee/SupplierNumber"/>
											</Id>
										</Othr>
									</OrgId>
								</Id>
							</Cdtr>
							<RmtInf>
								<Ustrd>
									<xsl:value-of select="DocumentPayable/DocumentNumber/ReferenceNumber"/>
								</Ustrd>
								<Strd>
									<RfrdDocInf>
										<Tp>
											<CdOrPrtry>
												<Cd>CINV</Cd>
											</CdOrPrtry>
										</Tp>
										<Nb>
											<xsl:value-of select="DocumentPayable/DocumentNumber/ReferenceNumber"/>
										</Nb>
										<RltdDt>
											<xsl:value-of select="DocumentPayable/DocumentDate"/>
										</RltdDt>
									</RfrdDocInf>
									<RfrdDocAmt>
										<DuePyblAmt>
											<xsl:attribute name="Ccy">
												<xsl:value-of select="PaymentAmount/Currency/Code"/>
											</xsl:attribute>
											<xsl:value-of select="PaymentAmount/Value"/>
										</DuePyblAmt>
										<DscntApldAmt>
											<xsl:attribute name="Ccy">
												<xsl:value-of select="PaymentAmount/Currency/Code"/>
											</xsl:attribute>
											<xsl:value-of select="DiscountTaken/Amount/Value"/>
										</DscntApldAmt>
										<RmtdAmt>
											<xsl:attribute name="Ccy">
												<xsl:value-of select="PaymentAmount/Currency/Code"/>
											</xsl:attribute>
											<xsl:value-of select="format-number(PaymentAmount/Value,'#.00')"/>
										</RmtdAmt>
									</RfrdDocAmt>
									<xsl:if test="not(DocumentPayable/DocumentDescription='')">
										<AddtlRmtInf>
											<xsl:value-of select="DocumentPayable/DocumentDescription"/>
										</AddtlRmtInf>
									</xsl:if>
								</Strd>
							</RmtInf>
						</CdtTrfTxInf>
					</PmtInf>
				</xsl:for-each>
			</CstmrCdtTrfInitn>
		</Document>
	</xsl:template>
</xsl:stylesheet>